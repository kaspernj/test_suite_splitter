Gem::Specification.new do |s|
  s.name = "test_suite_splitter".freeze
  s.version = "0.0.1"

  s.required_ruby_version = ">= 2.5.0"
  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["kaspernj".freeze]
  s.description = "Split your RSpec test suite up into several groups and run them in parallel.".freeze
  s.email = "k@spernj.org".freeze
  s.executables = ["test_suite_splitter".freeze]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = Dir["{bin,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]

  s.homepage = "http://github.com/kaspernj/test_suite_splitter".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Split your RSpec test suite up into several groups and run them in parallel.".freeze
  s.metadata = {"rubygems_mfa_required" => "true"}
  s.specification_version = 4 if s.respond_to? :specification_version

  s.add_development_dependency("bundler".freeze, [">= 0"])
  s.add_development_dependency("rspec".freeze, [">= 0"])
  s.add_development_dependency("rubocop".freeze, [">= 0"])
  s.add_development_dependency("rubocop-performance".freeze, [">= 0"])
  s.add_development_dependency("rubocop-rspec".freeze, [">= 0"])
end
