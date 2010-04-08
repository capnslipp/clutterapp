require 'string_rand_extension'


class Prop < ActiveRecord::Base
  self.abstract_class = true
  
  
  def value
    raise NotImplementedError, "must be implemented by the derived class, most easily accomplished via “prop_value_field :…”"
  end
  def value=(val)
    raise NotImplementedError, "must be implemented by the derived class, most easily accomplished via “prop_value_field :…”"
  end
  
  def self::prop_value_field(field_name)
    class_eval(<<-EOS, __FILE__, __LINE__)
      def value
        self.#{field_name}
      end
      def value=(val)
        self.#{field_name} = val
      end
    EOS
  end
  
  
  def self::derive_variant(type_or_name)
    if type_or_name.instance_of? Class
      variant = type_or_name
    else
      type_or_name = type_or_name.to_s.underscore.classify
      type_or_name << 'Prop' unless type_or_name =~ /Prop$/
      variant = type_or_name.constantize
    end
    raise %{variant "#{variant}" must be a subclass of Prop (not "Prop" itself; empty string passed in?)} unless variant.superclass == Prop
    variant
  end
  
  def self::short_name
    name = self.to_s
    raise NameError.new('all prop sub-classes must end in the word "Prop"', name) unless name =~ /Prop$/
    name = name[0...-('Prop'.length)]
    return name.underscore
  end
  
  def self::friendly_name
    return short_name.humanize.downcase
  end
  
  def variant
    self.class
  end
  def variant_name
    self.variant.short_name
  end
  
  def <=>(other)
    # sort in the same order as the Prop::variants() array
    Prop.variants.index(self.class) <=> Prop.variants.index(other.class)
  end
  
  
  def self::variants
    [TextProp, CheckProp, LinkProp, PriorityProp, TagProp, TimeProp, NoteProp, PileRefProp]
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
  
  
  # allows badge-style placement
  def self::badgeable?; false; end
  
  def self::is_badgeable
    (class << self; self; end).send :define_method, :badgeable? do
      true
    end
  end
  
  def badged?
    # if badgeable, then always badged, for now; will be position-dependent eventually
    self.class.badgeable?
  end
  
  
  # allows more than one of each on a parent node
  def self::stackable?; false; end
  
  def self::is_stackable
    (class << self; self; end).send :define_method, :stackable? do
      true
    end
  end
  
  
  # allow child nodes
  def self::nodeable?; false; end
  
  def self::is_nodeable
    (class << self; self; end).send :define_method, :nodeable? do
      true
    end
  end
  
  
  # allows "deep" placement (any deeper than a child of the root node)
  def self::deepable?; true; end
  
  def self::isnt_deepable
    (class << self; self; end).send :define_method, :deepable? do
      false
    end
  end
  
end
