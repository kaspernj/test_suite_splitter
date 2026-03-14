require "spec_helper"
require "rake"

describe "release rake tasks" do
  let(:rake_application) { Rake::Application.new }

  before do
    Rake.application = rake_application
    load File.expand_path("../../Rakefile", __dir__)
  end

  after do
    Rake.application = nil
  end

  it "invokes the patch release flow" do
    expect(TestSuiteSplitter::Release).to receive(:call).with({part: :patch})

    Rake::Task["release:patch"].invoke
  end

  it "maps release:path to release:patch" do
    expect(TestSuiteSplitter::Release).to receive(:call).with({part: :patch})

    Rake::Task["release:path"].invoke
  end
end
