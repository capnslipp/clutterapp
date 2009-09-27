class PriorityNodeCell < NodeCell
  
protected
  
  def new_prop
    PriorityProp.new(:pile => @pile)
  end
end
