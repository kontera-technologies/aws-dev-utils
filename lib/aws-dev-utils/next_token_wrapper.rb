module AwsDevUtils
  class NextTokenWrapper

    # Initialize a new NextTokenWrapper, internal use only
    # @params client [Aws client / NextTokenWrapper / RetryWrapper]
    # @param max [Integer] - max number of requests
    def initialize client, max=100
      @client = client
      @max = max
    end

    def method_missing method, *args, &block
      do_call(method, *args, &block)
    end

    private
    def do_call method, *args, &block
      @client.send(method, *args, &block).to_h.tap do |response|
        i = 1
        resp_keys, req_keys = extract_keys response

        resp_keys = Array(resp_keys)
        req_keys = Array(req_keys)

        next response if resp_keys.empty?

        props = args.first || {}
        while resp_keys.all?{ |resp_key| response[resp_key] } && i < @max do
          i += 1
          pagination_token_props =  Hash[req_keys.zip(resp_keys.map { |resp_key| response[resp_key] } ) ]
          new_response = @client.send(method, props.merge(pagination_token_props)).to_h
          new_response.each { |k,v| response[k] = v.is_a?(Array) ? response[k].concat(v) : v }
          response.delete_if { |k,v| !new_response.keys.include?(k) }
        end
        resp_keys.each { |resp_key| response.delete resp_key}
      end
    end

    def extract_keys x
      case
      when x[:next_token]
        [:next_token, :next_token]
      when x[:next_marker]
        [:next_marker, :marker]
      when x[:next_continuation_token]
        [:next_continuation_token, :continuation_token]
      when x[:next_record_name]
        [[:next_record_type, :next_record_name], [:start_record_type, :start_record_name]]
      else nil
      end
    end

  end
end
