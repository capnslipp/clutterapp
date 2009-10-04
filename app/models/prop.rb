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
      type << 'Prop' unless type =~ /Prop$/
      type = type.constantize
    end
  end
  
  
  def self::types
    [TextProp, CheckProp, NoteProp, PriorityProp, TagProp, TimeProp]
  end
  
  def self::rand
    types.rand.rand # 1st rand: choose from array; 2nd rand: create random instance
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
  
  
  # allows badge-style placement
  cattr_writer :badgeable
  def self::badgable?
    !!@@badgeable
  end
  
  # if badgable, then always badged, for now; will be position-dependent eventually
  def badged?
    self.class.badgable? ? true : false
  end
  
  
  # allows more than one on a parent node
  cattr_writer :stackable
  def self::stackable?
    !!@@stackable
  end
  
  # allow childs items
  cattr_writer :nodeable
  def self::nodeable?
    !!@@nodeable
  end
  
end
