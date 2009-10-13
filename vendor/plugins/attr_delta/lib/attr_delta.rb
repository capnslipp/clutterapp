module AttrDelta
  
  def self::included(base)
    base.extend(ClassMethods)
  end
  
  
  module ClassMethods
    
    def attr_delta(*names)
      names.each do |original_name|
        
        delta_name = "#{original_name}_delta"
        
        class_eval <<-EOS
          
          def #{delta_name}
            @#{delta_name} ||= 0
          end
          
          def #{delta_name}=(delta)
            @#{delta_name} = delta
          end
          
          def #{original_name}=(val)
            raise "Setting '#{original_name}' directly is forbidden."
          end
          
          before_save do |r|
            if r.new_record?
              r.write_attribute('#{original_name}', r.#{delta_name})
            else
              r.reload :select => '#{original_name}', :lock => true
              r.write_attribute('#{original_name}', r.read_attribute('#{original_name}') + r.#{delta_name})
            end
          end
          
        EOS
        
      end
    end
    
  end # ClassMethods
  
end # AttrDelta
