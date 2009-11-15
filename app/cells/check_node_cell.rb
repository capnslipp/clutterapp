class CheckNodeCell < NodeCell
  cache :show, :cache_version
  
  
  # check has no "new" or "edit" functionality
  undef_method :new, :edit
  
  
protected
  
  def new_prop
    CheckProp.new(:pile => @pile)
  end
end
