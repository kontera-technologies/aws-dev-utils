require 'singleton'
require 'forwardable'

module AwsDevUtils
  class Cache
    include Singleton

    #Allows to inject the cache type
    attr_writer :backend

    class << self
      extend Forwardable
      def_delegators :fetch
    end

    # Returns a value from the cache for the given key. 
    # If the key can't be found, the block will be run and its result returned and be set in the cache.
    # @param [Object] key 
    # @param [Time,Integer] exp
    # @param [block] block
    # @return [Object] the value from the cache or the result of the block
    def fetch key, exp=60, &block
      get(key) or block.().tap {|x| set(key, x, exp)}
    end

    # Get the value of key. If not found, returns nil
    def get key
      deserialize backend.get key.to_s rescue nil
    end

    # Set key to hold the value and set key to timeout after the a given expiration time(in seconds).
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
