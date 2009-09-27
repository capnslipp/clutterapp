class TagNodeCell < NodeCell
  
protected
  
  def new_prop
    TagProp.new(:pile => @pile)
  end
end
