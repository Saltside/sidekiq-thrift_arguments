require 'thrift'
require 'thrift/base64'
require 'sidekiq'

module Sidekiq
  module ThriftArguments
    class << self
      def included(base)
        base.extend ArgumentEncoder
        base.prepend ArgumentDecoder
      end
    end

    module ArgumentEncoder
      def perform_async(*args)
        thrift_encoded = args.map do |argument|
          case argument
          when Thrift::Struct
            {
              '__thrift__' => true,
              '__thrift_class__' => argument.class.name,
              '__thrift_blob__' => argument.to_base64
            }
          else
            argument
          end
        end

        super(*thrift_encoded)
      end
    end
  end

  module ArgumentDecoder
    def perform(*args)
      decoded = args.map do |argument|
        if argument.is_a?(Hash) && argument.key?('__thrift__')
          klass, blob = argument.fetch('__thrift_class__'), argument.fetch('__thrift_blob__')
          klass.constantize.from_base64 blob
        else
          argument
        end
      end

      super(*decoded)
    end
  end
end
