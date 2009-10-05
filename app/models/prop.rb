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
  
  def self::badgeable_types
    types.select {|t| t.badgeable? }
  end
  
  def self::stackable_types
    types.select {|t| t.stackable? }
  end
  
  def self::nodeable_types
    types.select {|t| t.nodeable? }
  end
  
  
  def self::rand_new
    types.rand.rand_new
  end
  
  def self::filler_new
    raise NotImplementedError
  end
  
  def increment_node_version
    unless node.nil?
      # independent of the current instance and hopefully leaner and safer, too
      Node::increment_counter :version, node.id
      node.after_prop_save
    end
  end
  
  def self::badgeable?; false; end
  # allows badge-style placement
  def self::is_badgeable
    class_eval(<<-EOS, __FILE__, __LINE__)
      def self::badgeable?; true; end
    EOS
  end
  
  def self::stackable?; false; end
  # allows more than one of each on a parent node
  def self::is_stackable
    class_eval(<<-EOS, __FILE__, __LINE__)
      def self::stackable?; true; end
    EOS
  end
  
  def self::nodeable?; false; end
  # allow child nodes
  def self::is_nodeable
    class_eval(<<-EOS, __FILE__, __LINE__)
      def self::nodeable?; true; end
    EOS
  end
  
  # if badgeable, then always badged, for now; will be position-dependent eventually
  def badged?
    self.class.badgeable? ? true : false
  end
  
end
