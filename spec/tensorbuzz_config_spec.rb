require "spec_helper"
require "yaml"

describe "TestSuiteSplitter" do
  describe "the tensorbuzz.yml path filter" do
    config = YAML.load_file(File.expand_path("../tensorbuzz.yml", __dir__))
    builds = config.fetch("builds")
    rspec_builds = builds.select { |_identifier, build| build.fetch("script").include?("bundle exec rspec") }
    rubocop_builds = builds.select { |_identifier, build| build.fetch("script").include?("bundle exec rubocop") }
    shared_install_inputs = ["Gemfile", "Gemfile.lock", "test_suite_splitter.gemspec", "VERSION"]
    paths_no_lane_reads = [".document", ".github/dependabot.yml", ".gitignore", "LICENSE.txt", "README.md"]

    def negations(build)
      build.fetch("paths").select { |pattern| pattern.start_with?("!") }.map { |pattern| pattern[1..-1] }
    end

    def covered_by_negation?(build, path)
      negations(build).any? do |pattern|
        pattern == path || (pattern.end_with?("/**") && path.start_with?(pattern[0..-3]))
      end
    end

    it "declares a non-empty paths list of glob strings on every build" do
      expect(builds).not_to be_empty

      builds.each do |_identifier, build|
        paths = build.fetch("paths")

        expect(paths).to be_an(Array)
        expect(paths).not_to be_empty
        expect(paths).to all(be_a(String))
        expect(paths).to all(satisfy { |pattern| !pattern.strip.empty? })
      end
    end

    it "keeps every build fail-open with the catch-all rule first, so an unlisted path still runs it" do
      builds.each do |_identifier, build|
        expect(build.fetch("paths").first).to eq("**")
      end
    end

    it "never negates a file the bundle install every lane runs depends on" do
      builds.each do |_identifier, build|
        expect(negations(build) & shared_install_inputs).to be_empty
      end
    end

    it "skips a lane only for paths that lane provably never reads" do
      paths_no_lane_reads.each do |path|
        builds.each do |_identifier, build|
          expect(covered_by_negation?(build, path)).to be(true), "#{path} is not covered by #{build.fetch("name")}"
        end
      end
    end

    it "keeps the rubocop config in the rubocop lane and out of the rspec lanes" do
      rubocop_builds.each do |_identifier, build|
        expect(negations(build)).not_to include(".rubocop.yml")
      end

      rspec_builds.each do |_identifier, build|
        expect(negations(build)).to include(".rubocop.yml")
      end
    end

    it "keeps the spec fixtures in the rspec lanes and out of the rubocop lane" do
      rubocop_builds.each do |_identifier, build|
        expect(negations(build)).to include("spec/**/*.json")
      end

      rspec_builds.each do |_identifier, build|
        expect(negations(build)).not_to include("spec/**/*.json")
      end
    end
  end
end
