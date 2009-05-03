# RackHacks

module Rack
  class Request
    def media_type
      content_type && content_type.to_s.split(/\s*[;,]\s*/, 2).first.downcase
    end
    
    def media_type_params
      return {} if content_type.nil?
      content_type.to_s.split(/\s*[;,]\s*/)[1..-1].
        collect { |s| s.split('=', 2) }.
        inject({}) { |hash,(k,v)| hash[k.downcase] = v ; hash }
    end
  end
end