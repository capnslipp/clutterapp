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
    [TextProp, CheckProp, NoteProp, PriorityProp, TagProp, TimeProp].rand.rand # 1st rand: choose from array; 2nd rand: create random instance
  end
  
end
