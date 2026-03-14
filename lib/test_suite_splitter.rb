module TestSuiteSplitter
  path = "#{__dir__}/test_suite_splitter"

  autoload :Release, "#{path}/release"
  autoload :RspecHelper, "#{path}/rspec_helper"
end
