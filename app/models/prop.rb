require 'string_rand_extension'


class Prop < ActiveRecord::Base
  # must be specified first (at least before any associations)
  after_save :increment_node_version
  
  self.abstract_class = true
  
  
  def self::class_from_type(type)
    if type.instance_of?(Class) && type.superclass == Prop
      type
    else
      type = type.to_s.classify
      type << 'Prop' unless type.match(/Prop$/)
      type = type.constantize
    end
  end
  
  
  def self::rand
    [TextProp, CheckProp, NoteProp, PriorityProp, TagProp, TimeProp].rand.rand # 1st rand: choose from array; 2nd rand: create random instance
  end
  
  def self::filler
    raise NotImplementedError
  end
  
  def increment_node_version
    unless node.nil?
      # independent of the current instance and hopefully leaner and safer, too
      Node::increment_counter :version, node.id
      node.after_prop_save
    end
  end
  
end
