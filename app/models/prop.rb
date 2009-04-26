require 'string_rand_extension'


class Prop < ActiveRecord::Base
  self.abstract_class = true
  
  
  def self.class_from_type(type)
    if type.instance_of?(Class) && type.superclass == Prop
      type
    else
      type = type.to_s.classify
      type << 'Prop' unless type.match(/Prop$/)
      type = type.constantize
    end
  end
  
  
  def self.rand
    [TextProp, CheckProp, NoteProp, PriorityProp, TagProp, TimeProp].rand.rand # 1st rand: choose from array; 2nd rand: create random instance
  end
  
end
