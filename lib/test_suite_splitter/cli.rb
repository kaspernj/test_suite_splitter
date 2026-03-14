class TestSuiteSplitter::Cli
  DEFAULT_LOG_FILE_PATH = "log/test_suite_splitter.log".freeze

  attr_reader :argv, :stderr, :stdout

  def initialize(argv:, stderr: $stderr, stdout: $stdout)
    @argv = argv
    @stderr = stderr
    @stdout = stdout
  end

  def execute_splitter_command
    print_output(group_file_paths.join(" "))
    0
  rescue StandardError => e
    handle_error(e)
  end

  def execute_rspec_command
    files = group_file_paths

    if files.empty?
      print_output("No files from test_suite_splitter - skipping shard")
      return 0
    end

    require "rspec/core"

    RSpec::Core::Runner.run(rspec_arguments + files, stderr, stdout)
  rescue StandardError => e
    handle_error(e)
  end

  def group_file_paths
    rspec_helper.group_files.map { |group_file| group_file.fetch(:path) }
  end

private

  def handle_error(error)
    message = error.message

    write_log(message)
    print_output("#{message}\n\nLogged to #{log_file_path}")

    1
  end

  def write_log(message)
    require "fileutils"

    FileUtils.mkdir_p(File.dirname(log_file_path))
    File.write(log_file_path, "#{message}\n")
  end

  def print_output(message)
    stdout.print(message)
  end

  def log_file_path
    @parsed_arguments&.fetch(:log_file) || DEFAULT_LOG_FILE_PATH
  end

  def rspec_helper
    @rspec_helper ||= TestSuiteSplitter::RspecHelper.new(**splitter_arguments)
  end

  def splitter_arguments
    parsed_arguments.slice(:exclude_path_prefixes, :exclude_types, :group_number, :groups, :only_types, :tags)
  end

  def rspec_arguments
    parsed_arguments.fetch(:rspec_arguments)
  end

  def parsed_arguments
    @parsed_arguments ||= begin
      result = {
        exclude_path_prefixes: nil,
        exclude_types: nil,
        log_file: DEFAULT_LOG_FILE_PATH,
        only_types: nil,
        rspec_arguments: [],
        tags: nil
      }
      parsing_splitter_arguments = true

      argv.each do |arg|
        if parsing_splitter_arguments && arg == "--"
          parsing_splitter_arguments = false
          next
        end

        if parsing_splitter_arguments
          key, value = parse_argument(arg)
          result[key] = value
        else
          result[:rspec_arguments] << arg
        end
      end

      result
    end
  end

  def parse_argument(argument)
    match = argument.match(/\A--(.+?)=(.+)\Z/)
    raise "Couldn't match argument: #{argument}" unless match

    key = match[1]
    value = match[2]

    case key
    when "exclude-path-prefixes", "exclude-types", "only-types", "tags"
      [key.tr("-", "_").to_sym, value.split(",")]
    when "group-number", "groups"
      [key.tr("-", "_").to_sym, value.to_i]
    when "log-file"
      [:log_file, value]
    else
      raise "Unknown argument: #{key}"
    end
  end
end
