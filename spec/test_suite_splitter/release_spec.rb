require "spec_helper"

describe TestSuiteSplitter::Release do
  describe ".call" do
    it "bumps the patch version and runs the release commands" do
      release = TestSuiteSplitter::Release.new(part: :patch)

      allow(File).to receive(:read).with(TestSuiteSplitter::Release::VERSION_FILE).and_return("0.0.1\n")
      expect(File).to receive(:write).with(TestSuiteSplitter::Release::VERSION_FILE, "0.0.2\n")
      expect(release).to receive(:system).with("git", "commit", "VERSION", "test_suite_splitter.gemspec", "-m", "Release 0.0.2").and_return(true)
      expect(release).to receive(:system).with("git", "push", "origin", "master").and_return(true)
      expect(release).to receive(:system).with("gem", "build", "test_suite_splitter.gemspec").and_return(true)
      expect(release).to receive(:system).with("gem", "push", "test_suite_splitter-0.0.2.gem").and_return(true)

      expect(release.call).to eq("0.0.2")
    end

    it "accepts the requested release:path alias" do
      release = TestSuiteSplitter::Release.new(part: :path)

      allow(File).to receive(:read).with(TestSuiteSplitter::Release::VERSION_FILE).and_return("1.2.3\n")
      expect(File).to receive(:write).with(TestSuiteSplitter::Release::VERSION_FILE, "1.2.4\n")
      expect(release).to receive(:system).exactly(4).times.and_return(true)

      expect(release.call).to eq("1.2.4")
    end

    it "raises when a release command fails" do
      release = TestSuiteSplitter::Release.new(part: :patch)

      allow(File).to receive(:read).with(TestSuiteSplitter::Release::VERSION_FILE).and_return("0.0.1\n")
      allow(File).to receive(:write)
      expect(release).to receive(:system).with("git", "commit", "VERSION", "test_suite_splitter.gemspec", "-m", "Release 0.0.2").and_return(false)

      expect do
        release.call
      end.to raise_error(RuntimeError, "Command failed: git commit VERSION test_suite_splitter.gemspec -m Release 0.0.2")
    end
  end
end
