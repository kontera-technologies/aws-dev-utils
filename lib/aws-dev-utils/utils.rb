module AwsDevUtils
  module Utils

    module_function

    # Transforms an object to a nested struct.
    # @return [OpenStruct]
    def nested_struct obj
      case obj
      when Hash
        obj.each_with_object(OpenStruct.new) do |(k,v), acc|
          acc[k]= case v
                  when Hash then send(__method__,v)
                  when Array then v.map(&method(__method__))
                  else v
                  end
          end.
          tap{|x| x.define_singleton_method(:keys){ obj.to_h.keys }}.
          tap{|x| x.define_singleton_method(:values){ AwsDevUtils::Utils.nested_struct obj.to_h.values }}
      when Array
        obj.map(&method(__method__))
      else
        obj
      end
    end

    # Transforms an object to a nested hash.
    # @return [Hash]
    def nested_hash obj
      if obj.kind_of? Array
        obj.map(&method(__method__))
      elsif obj.respond_to?(:to_h)
        obj.to_h.each_with_object({}) do |(k,v), acc|
          acc[k] = case v
                   when Hash,OpenStruct then send(__method__,v)
                   when Array then v.map(&method(__method__))
                   else v
                   end
        end
      else
        obj
      end
    end

  end
end
