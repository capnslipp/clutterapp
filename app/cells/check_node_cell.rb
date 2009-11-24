class CheckNodeCell < NodeCell
  #cache :show, :cache_version
  
  
protected
  
  def new_prop
    CheckProp.new(:pile => @pile)
  end
end
