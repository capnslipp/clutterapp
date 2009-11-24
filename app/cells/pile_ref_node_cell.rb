class PileRefNodeCell < NodeCell
  #cache :show, :cache_version
  
  
protected
  
  def determine_layout(state_name)
    "pile_ref_#{state_name}"
  end
  
  
  def new_prop
    PileRefProp.new(:pile => @pile)
  end
  
end
