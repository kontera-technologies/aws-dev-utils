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
      do_call(method,*args,&block)
    end

    private
    def do_call method, props = {}, &block
      @client.send(method, props, &block).to_h.tap do |response|
        i = 1
        resp_keys, req_keys = extract_keys response

        resp_keys = Array(resp_keys)
        req_keys = Array(req_keys)

        while(!resp_keys.empty? && resp_keys.all?{ |resp_key| response[resp_key] } && i < @max) do
          i += 1
          new_response = @client.send(
            method,
            props.merge(
              Hash[
                req_keys.zip(
                  resp_keys.map { |resp_key| response[resp_key] }
                )
              ]
            )
          ).to_h
          new_response.each { |k,v| response[k] = v.is_a?(Array) ? response[k].concat(v) : v }
          response.delete_if { |k,v| !new_response.keys.include?(k) }
        end
        response.delete resp_keys
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
