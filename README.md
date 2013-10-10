# Recess

[![Build Status](https://travis-ci.org/basecrm/recess.png?branch=master)](https://travis-ci.org/basecrm/recess)

Simple nestable timeouts for Ruby built on the Timeout module.

## Installation

Add this line to your application's Gemfile:

    gem 'recess'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install recess

## Usage

### Regular timeouts

Wrap your methods in timeouts like this:

```ruby
Recess::Timeouts.with_timeout(attempts, timeout) do
  Performer.possibly_slow_action
end
```

This will raise a ``Recess::TimeoutError`` when the maximum number of attempts is reached.

### Top-level timeouts

Nest regular timeouts within a top-level (hard) timeout to impose a top-level timeout like this:

```ruby
Recess::Timeouts.with_hard_timeout(attempts, timeout) do
  Recess::Timeouts.with_timeout(nested_attempts, nested_timeouts) do
    Performer.possibly_slow_action
  end
end
```

This will raise a ``Recess::HardTimeoutError`` when the global timeout expires and the desired number of attempts is reached.

Should the nested timeout be first to expire / reach the maximum attempts count, a regular ``Recess::TimeoutError`` will be raised.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
