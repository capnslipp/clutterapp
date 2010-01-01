class Node < ActiveRecord::Base
  self.abstract_class = true
  
  acts_as_nested_set :scope => :pile, :dependent => :destroy
  
  belongs_to :pile
  
  
  accepts_nested_attributes_for :children, :allow_destroy => true
  
  
  # named_scope must be in the same class as the has_many relation (i.e. this class), apparently
  
  named_scope :varianted, lambda {|variant_or_name|
    { :conditions => {:prop_type => Prop.derive_variant(variant_or_name).to_s} }
  }
  
  named_scope :badgeable,     :conditions => {:prop_type => Prop.badgeable_variants.collect(&:to_s)}
  named_scope :non_badgeable, :conditions => {:prop_type => Prop.non_badgeable_variants.collect(&:to_s)}
  
  named_scope :stackable,     :conditions => {:prop_type => Prop.stackable_variants.collect(&:to_s)}
  named_scope :non_stackable, :conditions => {:prop_type => Prop.non_stackable_variants.collect(&:to_s)}
  
  named_scope :nodeable,      :conditions => {:prop_type => Prop.nodeable_variants.collect(&:to_s)}
  named_scope :non_nodeable,  :conditions => {:prop_type => Prop.non_nodeable_variants.collect(&:to_s)}
  
  named_scope :deepable,      :conditions => {:prop_type => Prop.deepable_variants.collect(&:to_s)}
  named_scope :non_deepable,  :conditions => {:prop_type => Prop.non_deepable_variants.collect(&:to_s)}
  
  
  def <=>(other)
    self.class <=> other.class
  end
  
end
