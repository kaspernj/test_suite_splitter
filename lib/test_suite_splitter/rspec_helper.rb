class TestSuiteSplitter::RspecHelper
  attr_reader :exclude_types, :only_types, :tags

  def initialize(groups:, group_number:, exclude_types: nil, only_types: nil, tags: nil)
    @exclude_types = exclude_types
    @groups = groups
    @group_number = group_number
    @example_data_exists = File.exist?("spec/examples.txt")
    @only_types = only_types
    @tags = tags
  end

  def example_data_exists?
    @example_data_exists
  end

  def example_data
    @example_data ||= begin
      raw_data = File.read("spec/examples.txt")

      result = []
      raw_data.scan(/^\.\/(.+)\[(.+?)\]\s+\|\s+(.+?)\s+\|\s+((.+?) seconds|)\s+\|$/) do |match|
        file_path = match[0]
        spec_result = match[1]
        seconds = match[4]&.to_f

        spec_data = {
          file_path: file_path,
          spec_result: spec_result,
          seconds: seconds
        }

        result << spec_data
      end

      result
    end
  end

  def example_files
    @example_files ||= begin
      files = {}
      example_data.each do |spec_data|
        file_path = spec_data.fetch(:file_path)
        seconds = spec_data.fetch(:seconds)

        files[file_path] ||= {examples: 0, seconds: 0.0}
        files[file_path][:examples] += 1
        files[file_path][:seconds] += seconds if seconds
      end

      files
    end
  end

  def example_file(path)
    example_files[path]
  end

  def group_files
    return @group_files if @group_files

    sorted_files.each do |file|
      file_path = file.fetch(:path)
      file_data = example_file(file_path) if example_data_exists?

      if file_data
        examples = file_data.fetch(:examples)
        seconds = file_data.fetch(:seconds)
      else
        examples = file.fetch(:examples)
      end

      group = group_with_least
      group[:examples] += examples
      group[:files] << file
      group[:seconds] += seconds if seconds
    end

    @group_files = group_orders[@group_number - 1].fetch(:files)
  end

  def group_orders
    @group_orders ||= begin
      group_orders = []
      @groups.times do
        group_orders << {
          examples: 0,
          files: [],
          seconds: 0.0
        }
      end
      group_orders
    end
  end

  def group_with_least
    group_orders.min do |group1, group2|
      if example_data_exists? && group1.fetch(:seconds) != 0.0 && group2.fetch(:seconds) != 0.0
        group1.fetch(:seconds) <=> group2.fetch(:seconds)
      else
        group1.fetch(:examples) <=> group2.fetch(:examples)
      end
    end
  end

  # Sort them so that they are sorted by file path in three groups so each group have an equal amount of controller specs, features specs and so on
  def sorted_files
    files.values.sort do |file1, file2|
      file1_path = file1.fetch(:path)
      file2_path = file2.fetch(:path)

      file1_data = example_file(file1_path) if example_data_exists?
      file2_data = example_file(file2_path) if example_data_exists?

      if file1_data && file2_data && file1_data.fetch(:seconds) != 0.0 && file2_data.fetch(:seconds) != 0.0
        value1 = file1_data[:seconds]
      else
        value1 = file1.fetch(:points)
      end

      if file2_data && file1_data && file2_data.fetch(:seconds) != 0.0 && file2_data.fetch(:seconds) != 0.0
        value2 = file2_data[:seconds]
      else
        value2 = file2.fetch(:points)
      end

      if value1 == value2
        value2 = file1_path
        value1 = file2_path
      end

      value2 <=> value1
    end
  end

private

  def dry_result
    @dry_result ||= begin
      require "json"
      require "rspec/core"
      require "stringio"

      output_capture = StringIO.new
      RSpec::Core::Runner.run(rspec_options, $stderr, output_capture)

      result = ::JSON.parse(output_capture.string)

      raise "No examples were found" if result.fetch("examples").empty?

      result
    end
  end

  def dry_file(path)
    files.fetch(path)
  end

  def files
    @files ||= begin
      result = {}
      dry_result.fetch("examples").each do |example|
        file_path_id = example.fetch("id")
        file_path = example.fetch("file_path")

        next if example.fetch("description") != "views the fixed content and submits answers"

        file_path = file_path[2, file_path.length]
        type = type_from_path(file_path_id)
        points = points_from_type(type)

        next if ignore_type?(type)

        result[file_path] = {examples: 0, path: file_path, points: 0, type: type} unless result.key?(file_path)
        result[file_path][:examples] += 1
        result[file_path][:points] += points
      end

      result
    end
  end

  def ignore_type?(type)
    return true if only_types && !only_types.include?(type)
    return true if exclude_types&.include?(type)

    false
  end

  def points_from_type(type)
    if type == "system"
      20
    elsif type == "feature"
      10
    elsif type == "controllers"
      3
    else
      1
    end
  end

  def rspec_options
    rspec_options = ["--dry-run", "--format", "json"]

    tags&.each do |tag|
      rspec_options += ["--tag", tag]
    end

    # Add the folder with all the specs, which is required when running programmatically
    rspec_options << "spec"

    rspec_options
  end

  def type_from_path(file_path)
    match = file_path.match(/^\.\/spec\/(.+?)\//)
    match[1] if match
  end
end
