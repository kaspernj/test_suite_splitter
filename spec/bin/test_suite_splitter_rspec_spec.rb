require "spec_helper"
require "fileutils"
require "open3"
require "tmpdir"

describe "bin/test_suite_splitter_rspec" do
  it "runs rspec for the selected shard files" do
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p("#{dir}/spec/system")
      FileUtils.mkdir_p("#{dir}/spec/unit")
      File.write(
        "#{dir}/spec/system/pass_spec.rb",
        <<~RUBY
          RSpec.describe "system pass", type: :system do
            it "passes" do
              raise "excluded spec should not run"
            end
          end
        RUBY
      )
      File.write(
        "#{dir}/spec/unit/pass_spec.rb",
        <<~RUBY
          RSpec.describe "unit pass" do
            it "passes" do
              expect(true).to be(true)
            end
          end
        RUBY
      )

      stdout, stderr, status = Open3.capture3(
        "ruby",
        File.expand_path("../../bin/test_suite_splitter_rspec", __dir__),
        "--groups=1",
        "--group-number=1",
        "--exclude-path-prefixes=spec/system/",
        "--",
        "--format",
        "documentation",
        chdir: dir
      )

      expect(status.success?).to be true
      expect(stdout + stderr).not_to include("excluded spec should not run")
    end
  end
end
