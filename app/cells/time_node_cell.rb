class TimeNodeCell < NodeCell
  cache :show, :cache_version
  
  
protected
  
  def new_prop
    TimeProp.new(:pile => @pile)
  end
end
