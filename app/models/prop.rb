require 'string_rand_extension'


class Prop < ActiveRecord::Base
  self.abstract_class = true
  
  
  def self::class_from_type(type)
    unless type.instance_of?(Class)
      type = type.to_s.underscore.classify
      type << 'Prop' unless type =~ /Prop$/
      type = type.constantize
    end
    raise %{type "#{type}" must be a subclass of Prop (not "Prop" itself; empty string passed in?)} unless type.superclass == Prop
    type
  end
  
  def self::short_name
    name = self.to_s
    raise NameError.new('all prop sub-classes must end in the word "Prop"', name) unless name =~ /Prop$/
    name = name[0...-('Prop'.length)]
    name.underscore.dasherize
  end
  
  def variant_name
    self.class.short_name
  end
  
  def <=>(other)
    # sort in the same order as the Prop::variants() array
    Prop.variants.index(self.class) <=> Prop.variants.index(other.class)
  end
  
  
  def self::variants
    [TextProp, CheckProp, PriorityProp, TagProp, TimeProp, NoteProp, PileRefProp]
  end
  
  def self::badgeable_variants
    @badgeable_variants ||= variants.select {|t| t.badgeable? }
  end
  def self::non_badgeable_variants
    @non_badgeable_variants ||= variants - badgeable_variants
  end
  
  def self::stackable_variants
    @stackable_variants ||= variants.select {|t| t.stackable? }
  end
  def self::non_stackable_variants
    @non_stackable_variants ||= variants - stackable_variants
  end
  
  def self::nodeable_variants
    @nodeable_variants ||= variants.select {|t| t.nodeable? }
  end
  def self::non_nodeable_variants
    @non_nodeable_variants ||= variants - nodeable_variants
  end
  
  def self::deepable_variants
    @deepable_variants ||= variants.select {|t| t.deepable? }
  end
  def self::non_deepable_variants
    @non_deepable_variants ||= variants - deepable_variants
  end
  
  
  def self::rand_new
    variants.rand.rand_new
  end
  
  def self::filler_new
    raise NotImplementedError
  end
  
  
  def self::abilities
    [:badgeable, :stackable, :nodeable, :deepable]
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
  
  def self::deepable?; true; end
  # disallow "deep" placement (any deeper than a child of the root node)
  def self::isnt_deepable
    class_eval(<<-EOS, __FILE__, __LINE__)
      def self::deepable?; false; end
    EOS
  end
  
end
