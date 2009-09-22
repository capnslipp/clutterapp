module ActiveSupport
  class BufferedLogger
    
    ESCAPE_CHR = 0x1b.chr
    
    def prefix(text, color = nil)
      if color.nil?
        "  #{text}   "
      else
        "  #{ESCAPE_CHR}[4;#{color_code(color).join(';')}m#{text}#{ESCAPE_CHR}[0m   "
      end
    end
    
    
  private
    
    def color_code(color_sym)
      case color_sym.to_sym
        when :red:          [0, 31]
        when :light_red:    [1, 31]
        when :green:        [0, 32]
        when :light_green:  [1, 32]
        when :blue:         [0, 34]
        when :light_blue:   [1, 34]
        
        when :cyan:         [0, 36]
        when :light_cyan:   [1, 36]
        when :magenta:      [0, 35]
        when :light_magenta:[1, 35]
        when :yellow:       [0, 33]
        when :light_yellow: [1, 33]
        
        when :black;        [0, 30]
        when :dark_gray:    [1, 30]
        when :light_gray:   [0, 37]
        when :white:        [1, 37]
        
        when :default:      [0, 39]
        else                [0, 39]
      end
    end
    
  end
end