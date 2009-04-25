require 'string_rand_extension'


class Prop < ActiveRecord::Base
  self.abstract_class = true
  
  
  def Prop.from_type(*args) 
    o = allocate
    o.send(:initialize_from_type, *args)
    o
  end
  
  
  def initialize_from_type(prop_type)
    ## for constructing inherited classes through this class
    if prop_type.instance_of?(Class) && prop_type.superclass == Prop
      return prop_type.new
    ## for constructing inherited classes through this class
    else
      prop_type = prop_type.to_s.classify
      prop_type << 'Prop' unless prop_type.match(/Prop$/)
      prop_type = prop_type.constantize
      return prop_type.new
    end
  end
  
  
  def self.rand
    prop = [TextProp, CheckProp, NoteProp, PriorityProp, TagProp, TimeProp].rand.new
    case prop
      when TextProp:      prop.text = String.rand_lorem(5)
      when CheckProp:     prop.checked = (Kernel.rand(1 + 1) == 1)
      when NoteProp:      prop.note = String.rand_lorem(50)
      when PriorityProp:  prop.priority = Kernel.rand(5 + 1)
      when TagProp:	      prop.tag = String.rand_alphanum(4)
      when TimeProp:	    prop.time = Time.now - Kernel.rand(59).minutes - Kernel.rand(23).hours - Kernel.rand(364).days - Kernel.rand(100).years
      else
        return nil
    end
    prop
  end
  
end
