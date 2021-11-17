# Generated by juwelier
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Juwelier::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: test_suite_splitter 0.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "test_suite_splitter".freeze
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["kaspernj".freeze]
  s.date = "2021-11-17"
  s.description = "Split your RSpec test suite up into several groups and run them in parallel.".freeze
  s.email = "k@spernj.org".freeze
  s.executables = ["test_suite_splitter".freeze]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rubocop.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/test_suite_splitter",
    "lib/test_suite_splitter.rb",
    "lib/test_suite_splitter/rspec_helper.rb",
    "peak_flow.yml",
    "spec/spec_helper.rb",
    "spec/test_suite_splitter/rspec_helper/nemoa_rspec_output.json",
    "spec/test_suite_splitter/rspec_helper_spec.rb",
    "test_suite_splitter.gemspec"
  ]
  s.homepage = "http://github.com/kaspernj/test_suite_splitter".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Split your RSpec test suite up into several groups and run them in parallel.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<juwelier>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop-performance>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop-rspec>.freeze, [">= 0"])
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<juwelier>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-performance>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-rspec>.freeze, [">= 0"])
  end
end

