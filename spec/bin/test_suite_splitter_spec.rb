require "spec_helper"
require "fileutils"
require "open3"
require "tmpdir"

describe "bin/test_suite_splitter" do
  it "prints the underlying rspec load error to stdout" do
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p("#{dir}/spec")
      File.write("#{dir}/spec/broken_spec.rb", "this is not valid ruby\n")

      stdout, stderr, status = Open3.capture3("ruby", File.expand_path("../../bin/test_suite_splitter", __dir__), "--groups=1", "--group-number=1", chdir: dir)

      expect(status.success?).to be false
      expect(stdout).to include("RSpec dry-run failed")
      expect(stdout).to include("An error occurred while loading ./spec/broken_spec.rb.")
      expect(stdout).to include("this is not valid ruby")
      expect(stderr).to eq("")
    end
  end
end
