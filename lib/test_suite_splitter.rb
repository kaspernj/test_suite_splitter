module TestSuiteSplitter
  path = "#{__dir__}/test_suite_splitter"

  autoload :Cli, "#{path}/cli"
  autoload :Release, "#{path}/release"
  autoload :RspecHelper, "#{path}/rspec_helper"
end
