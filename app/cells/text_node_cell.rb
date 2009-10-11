class TextNodeCell < NodeCell
  cache :show, :cache_version
  
  
protected
  
  def new_prop
    TextProp.new(:pile => @pile)
  end
end
