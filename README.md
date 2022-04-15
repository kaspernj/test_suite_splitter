# test_suite_splitter

Add it to your Gemfile:
```ruby
group :test do
  gem "test_suite_splitter", require: false
end
```

Change your CI configuration file to execute something like this:
```bash
bundle exec rspec `bundle exec test_suite_splitter --groups=6 --group-number=3`
```

On Semaphore that could be done dynamically like this:
```bash
bundle exec rspec `bundle exec test_suite_splitter --groups=${SEMAPHORE_JOB_COUNT} --group-number=${SEMAPHORE_JOB_INDEX}`
```

Run only a certain type of specs:
```bash
bundle exec rspec `bundle exec test_suite_splitter --groups=6 --group-number=3 --only-types=system,model`
```

Exclude a certain type of specs:
```bash
bundle exec rspec `bundle exec test_suite_splitter --groups=6 --group-number=3 --exclude-types=system,feature`
```

## Contributing to test_suite_splitter
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2021 kaspernj. See LICENSE.txt for
further details.
