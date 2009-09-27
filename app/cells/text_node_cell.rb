class TextNodeCell < NodeCell
  
protected
  
  def new_prop
    TextProp.new(:pile => @pile)
  end
end
