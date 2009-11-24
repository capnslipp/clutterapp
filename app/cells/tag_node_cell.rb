class TagNodeCell < NodeCell
  #cache :show, :cache_version
  
  
protected
  
  def new_prop
    TagProp.new(:pile => @pile)
  end
end
