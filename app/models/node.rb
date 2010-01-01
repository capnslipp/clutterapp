class Node < ActiveRecord::Base
  self.abstract_class = true
  
  acts_as_nested_set :scope => :pile, :dependent => :destroy
  
  belongs_to :pile
  
  
  accepts_nested_attributes_for :children, :allow_destroy => true
  
  
  def <=>(other)
    self.class <=> other.class
  end
  
end
