module ConstReader
  
  def self::included(base)
    base.extend(ClassMethods)
  end
  
  
  module ClassMethods
    
    def const_reader(*syms)
      syms.flatten.each do |sym|
        next if sym.is_a?(Hash)
        
        class_eval(<<-EOS, __FILE__, __LINE__)
          def #{sym.to_s.underscore}      # def widget_color
            #{sym.to_s.underscore.upcase} #   WIDGET_COLOR
          end                             # end
        EOS
      end
    end
    
  end
  
end
