module ActiveSupport
  class BufferedLogger
    
    def prefix(text, color_code = nil, use_bright_shade = true)
      if color_code.nil?
        "  #{text}   "
      else
        "  [4;#{color_code.to_i};#{color_code ? 1 : 0}m#{text}[0m   "
      end
    end
  
  end
end