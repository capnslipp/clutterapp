class CheckNodeCell < NodeCell
  cache :show, :cache_version
  
  
  # check has no "new" or "edit" functionality
  def new
    show.merge(:view => 'show')
  end
  
  
protected
  
  def new_prop
    CheckProp.new(:pile => @pile)
  end
end
