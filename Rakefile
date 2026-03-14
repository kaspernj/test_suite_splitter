require "rubygems"
require "bundler"
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end
require "rake"
require_relative "lib/test_suite_splitter"
task default: :test

require "rdoc/task"
Rake::RDocTask.new do |rdoc|
  version = File.exist?("VERSION") ? File.read("VERSION") : ""

  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "test_suite_splitter #{version}"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

namespace :release do
  desc "Bump the patch version, commit it, push master, build the gem, and push it"
  task :patch do
    TestSuiteSplitter::Release.call(part: :patch)
  end

  task path: :patch
end
