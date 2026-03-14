module TestSuiteSplitter
end

class TestSuiteSplitter::Release
  VERSION_FILE = File.expand_path("../../VERSION", __dir__)
  GEMSPEC_FILE = "test_suite_splitter.gemspec".freeze
  MASTER_BRANCH = "master".freeze

  def self.call(part: :patch)
    new(part: part).call
  end

  def initialize(part:)
    @part = part.to_sym
  end

  def call
    next_version = bumped_version
    write_version(next_version)
    run("git", "commit", "VERSION", GEMSPEC_FILE, "-m", "Release #{next_version}")
    run("git", "push", "origin", MASTER_BRANCH)
    run("gem", "build", GEMSPEC_FILE)
    run("gem", "push", gem_file_name(next_version))
    next_version
  end

private

  attr_reader :part

  def bumped_version
    case part
    when :patch, :path
      major, minor, patch = current_version_segments
      [major, minor, patch + 1].join(".")
    else
      raise ArgumentError, "Unsupported release part: #{part}"
    end
  end

  def current_version
    File.read(VERSION_FILE).strip
  end

  def current_version_segments
    segments = current_version.split(".").map do |segment|
      Integer(segment, 10)
    rescue ArgumentError
      raise ArgumentError, "Invalid version: #{current_version}"
    end

    raise ArgumentError, "Invalid version: #{current_version}" unless segments.length == 3

    segments
  end

  def gem_file_name(version)
    "test_suite_splitter-#{version}.gem"
  end

  def run(*command)
    success = system(*command)
    raise "Command failed: #{command.join(' ')}" unless success
  end

  def write_version(version)
    File.write(VERSION_FILE, "#{version}\n")
  end
end
