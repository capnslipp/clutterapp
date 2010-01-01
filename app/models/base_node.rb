class BaseNode < Node
  
  
protected
  
  # override's Node's validate, eliminating the need to have a Prop or be non-root
  def validate
    errors.add(:base_node, "must be root") unless root?
    errors.add(:base_node, "must not have a prop") if prop
  end
  
end
