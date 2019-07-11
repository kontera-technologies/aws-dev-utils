require 'singleton'
require 'forwardable'

module AwsDevUtils
  class Cache
    include Singleton

    #for testing
    attr_writer :backend

    class << self
      extend Forwardable
      def_delegators :fetch
    end

    def fetch key, exp=60, &block
      get(key) or block.().tap {|x| set(key, x, exp)}
    end

    def get key
      deserialize backend.get key.to_s rescue nil
    end

    def set key, value, expiration
      backend.set key.to_s, serialize(value), expiration rescue nil
    end

    private

    def backend
      @backend ||= AwsDevUtils::Backend::Memory.new
    end

    def serialize obj
      Marshal.dump obj
    end

    def deserialize obj
      Marshal.load obj
    end

  end
end
