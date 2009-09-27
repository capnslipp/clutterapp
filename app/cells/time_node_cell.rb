class TimeNodeCell < NodeCell
  
protected
  
  def new_prop
    TimeProp.new(:pile => @pile)
  end
end
