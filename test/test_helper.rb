require 'bundler/setup'

root = File.expand_path '../..', __FILE__

$LOAD_PATH << "#{root}/vendor/gen-rb"

require 'sidekiq-thrift_arguments'

Thrift.type_checking = true

require 'sidekiq/testing'

require 'test_types'
require 'minitest/autorun'
