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
require "juwelier"
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "test_suite_splitter"
  gem.homepage = "http://github.com/kaspernj/test_suite_splitter"
  gem.license = "MIT"
  gem.summary = "Split your RSpec test suite up into several groups and run them in parallel."
  gem.description = "Split your RSpec test suite up into several groups and run them in parallel."
  gem.email = "k@spernj.org"
  gem.authors = ["kaspernj"]

  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new
require "rake/testtask"
Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/test_*.rb"
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV["COVERAGE"] = "true"
  Rake::Task["test"].execute
end

task default: :test

require "rdoc/task"
Rake::RDocTask.new do |rdoc|
  version = File.exist?("VERSION") ? File.read("VERSION") : ""

  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "test_suite_splitter #{version}"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
end
