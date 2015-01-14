require_relative 'test_helper'

class AcceptanceTest < MiniTest::Unit::TestCase
  class CountPeople
    include Sidekiq::Worker
    include Sidekiq::ThriftArguments

    COUNTED = [ ]

    class << self
      def counted
        COUNTED
      end
    end

    # This method uses Person instance and calls a method. It tests the
    # job does received a deserialized Person instance. It would be nice
    # to assert on the result of this method, but perform_async only returns
    # the job id. So here the counted people are stored in a constant so
    # its members can be referenced after a job is processed.
    def perform(person, count = true)
      return unless count
      COUNTED << person.name
    end
  end

  def setup
    CountPeople.counted.clear
  end

  def test_roundtrips_thrift_classes
    Sidekiq::Testing.inline! do
      person = Person.new name: 'adam'

      CountPeople.perform_async Person.new(name: 'adam'), true
      CountPeople.perform_async Person.new(name: 'terje'), true
      CountPeople.perform_async Person.new(name: 'foo'), false

      assert_equal 2, CountPeople.counted.size
    end
  end
end
