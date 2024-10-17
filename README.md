# Monotonic

Provide a cross-platform monotonic time for ruby even across system suspense.
The timer starts from 0 on system boot and will reset on system reboot.

The monotonic timer is useful as a measure of passing time and shouldn't compared with time from other sources.
The timestamps are also only safely compared when sourced from the same thread.

## Usage

```ruby
Monotonic.monotonic_time
# => 91226002327716
```

## Why?

The state of cross-platform time keeping is a mess. 
In Linux alone, there are 11 different clocks.
The usual recommendation is to use `Process::CLOCK_MONOTONIC` for a monotonic time. 

In a lot of cases `CLOCK_MONOTONIC` works fine, but the clock stops on system suspense.
If you're attempting to bound the running time with for example `Timeout`, then it's important to be aware that `CLOCK_MONOTONIC` may not timeout in the desired time when compared to "real" time:

```ruby
Timeout.timeout(5) do
    # Do Work
    # System is supsended for 15 minutes
    # Continue working as if nothing happened
end
# Total running time 15 minutes
```

Currently, there's no good option for getting a suspense-aware cross-platform monotonic timestamp. 
On Linux/FreeBSD it's possible to use `CLOCK_BOOTTIME`.

However, Ruby hasn't implemented the MacOS equivalent of `mach_continous_time`.
Windows also has a poor story regarding high precision timers, with the only option being `QueryPerformanceCounter` for a high resolution time stamp.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add ruby-monotonic
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install ruby-monotonic
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/richardmarbach/monotonic.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
