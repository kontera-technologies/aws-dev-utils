module AwsDevUtils
  class ClientWrapper
    include AwsDevUtils::Utils

    # Initialize a new ClientWrapper, internal use only
    # @params [Seahorse::Client::Base] client
    # @param [Hash] options
    # @option options [String] next_token max number of requests
    # @option options [String] retry max number of retries
    # @option options [String] cache the key-value timeout
    def initialize client, options={}
      @client = client
      @options = options
    end

    # @return ClientWrapper with next_token option
    def with_next_token max=NextTokenWrapper::DEFAULT_MAX
      self.class.new(@client, @options.merge(next_token: max))
    end

    # @return ClientWrapper with retry option
    def with_retry max=5
      self.class.new(@client, @options.merge(retry: max))
    end

    # @return ClientWrapper with cache option
    def with_cache exp=60
      self.class.new(@client, @options.merge(cache: exp))
    end

    def method_missing m, *args, &block
      client_name = @client.class.name
      @client = RetryWrapper.new(@client, @options[:retry]) if retry?
      @client = NextTokenWrapper.new(@client, @options[:next_token]) if next_token?
      @client = CacheWrapper.new(@client, @options[:cache], client_name: client_name) if cache?

      nested_struct(@client.send(m, *args, &block))
    end

    private

    def cache?
      @options[:cache]
    end

    def retry?
      @options[:retry]
    end

    def next_token?
      @options[:next_token]
    end

  end
end
