module ActiveSupport
  class BufferedLogger
    
    ESCAPE_CHR = 0x1b.chr
    PREFIX_SPACE = '  '
    SUFFIX_SPACE = '   '
    
    
    def prefix(text, color = nil)
      if color.nil?
        "#{PREFIX_SPACE}#{text}   "
      else
        "#{PREFIX_SPACE}#{ESCAPE_CHR}[4;#{color_code(color).join(';')}m#{text}#{ESCAPE_CHR}[0m#{SUFFIX_SPACE}"
      end
    end
    
    
    def add_with_prefix(severity, message = nil, progname = nil, &block)
      prefix = case severity
        when DEBUG:   prefix('DEBUG', :blue)
        when INFO:    prefix('INFO', :green)
        when WARN:    prefix('WARN', :yellow)
        when ERROR:   prefix('ERROR', :red)
        when FATAL:   prefix('FATAL', :light_red)
        when UNKNOWN: prefix('UNKNOWN', :light_gray)
        else          ''
      end unless message =~ /^  /
      
      add_without_prefix(severity, message.nil? ? nil : "#{prefix}#{message}", progname, &block)
    end
    
    alias_method_chain :add, :prefix
    
    
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