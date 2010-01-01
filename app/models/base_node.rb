class BaseNode < Node
  
  
protected
  
  # override's Node's validate, eliminating the need to have a Prop or be non-root
  def validate
    errors.add(:base_node, "must be root") unless root?
  end
  
end
