# BetterCallRedis

[![Build Status](https://api.travis-ci.org/clod81/better_call_redis.svg)](http://travis-ci.org/clod81/better_call_redis)

Active Record Callback that pushes a notification on a Redis channel when an active record model is created or deleted.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'better_call_redis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install better_call_redis

## Usage

### Initializer

All those initialize options are optional.
"Redis.new" will be used with default connection options if not specified.
"bettercallredis:notification" is the default namespace.
"deleted_attributes" for logically deleted active record models (ex: table column deleted or cancelled). Default is an empty array.

```ruby
BetterCallRedis::configure do |bcr|
  bcr.redis              = Redis.new
  bcr.namespace          = "bettercallredis:notification"
  bcr.deleted_attributes = %w(deleted cancelled)
end
```

### Include in your active record model(s)

Include the following in your active record model class to enable redis channel notification messages.

```ruby
include BetterCallRedis::ActiveRecord
```

### Redis message

Example for save a new record of class User << ActiveRecord::Base

```ruby
{:class_name => "User", :message => 1}.to_json
```

Example for deleting an existing record of class User << ActiveRecord::Base

```ruby
{:class_name => "User", :message => -1}.to_json
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/better_call_redis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Thanks
