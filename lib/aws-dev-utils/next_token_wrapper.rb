module AwsDevUtils
  class NextTokenWrapper

    DEFAULT_MAX=100

    # Initialize a new NextTokenWrapper, internal use only
    # @params client [Aws client / NextTokenWrapper / RetryWrapper]
    # @param max [Integer] - max number of requests
    def initialize client, max=DEFAULT_MAX
      @client = client
      @max = max
    end

    def method_missing method, *args, &block
      do_call(method, *args, &block)
    end

    private
    def do_call method, *args, &block
      response = @client.send(method, *args, &block).to_h
      i = 1
      req_keys, next_req_keys = extract_keys response

      return response if req_keys.nil?

      props = args.first || {}
      while req_keys.all?{ |req_keys| response[req_keys] } && i < @max do
        i += 1
        pagination_token_props =  Hash[next_req_keys.zip(req_keys.map { |req_keys| response[req_keys] } ) ]
        new_response = @client.send(method, props.merge(pagination_token_props)).to_h

        new_response.each { |k,v| new_response[k] = v.is_a?(Array) ? response[k]+new_response[k] : v }

        response = new_response
      end

      req_keys.each { |req_keys| response.delete req_keys}
      response
    end

    def extract_keys response
      case
      when response[:next_token]
        [[:next_token], [:next_token]]
      when response[:next_marker]
        [[:next_marker], [:marker]]
      when response[:next_continuation_token]
        [[:next_continuation_token], [:continuation_token]]
      when response[:next_record_name]
        [[:next_record_type, :next_record_name], [:start_record_type, :start_record_name]]
      else nil
      end
    end

  end
end
