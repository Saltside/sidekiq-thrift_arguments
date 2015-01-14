# Sidekiq::ThriftArguments

This library transparent handles and serializing & deserializing
`Thrift::Struct` instances used as job arguments. This is a tedious
process because `Thrift::Struct` instances **cannot** be used
transparently with `JSON.dump` and `JSON.load`. The internal JSON
serializers must be used. So in pratice there would be code like this:

```ruby
class SomeWorker
  include Sidekiq::Worker

  def perform(json_blob)
    deserializer = Thrift::Deserializer.new Thrift::JsonProtocolFactory.new
	struct = deserializer.deserialize(MyThriftStruct.new, json_blob)

	# do the work ...
  end
end

serializer = Thrift::Serializer.new Thrift::JsonProtocolFactory.new
SomeWorker.perform_async serializer.serialize(some_thrift_struct)
```

This code functions as you'd expect. First, serialize the thrift
struct to a JSON string. The worker class accepts a serialized thrift
blob it can deserialize into the required object. This is fine and
dandy when you have a few classes. It gets out of hand when you have
repeated the same thing in the same codebase and then across multiple
codebases. There is also a slight problem in that you must know the
class you want to deserialize into. This makes it hard to abstract the
code in some cases. This library solves this problem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-thrift_arguments'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-thrift_arguments

## Usage

Usage is simple. `include Sidekiq::ThriftArguments` after including
`Sidekiq::Worker`. Here's an example:

```ruby
class ThriftWorker
  include Sidekiq::Worker
  # Important! You need to include this after, not before.
  include Sidekiq::ThriftArguments
end
```

Now you can call `perform_async` and `perform` with `Thrift::Struct`
instances as you would with any other method.

## Testing

    $ make test

## Contributing

1. Fork it ( https://github.com/saltside/sidekiq-thrift_arguements/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
