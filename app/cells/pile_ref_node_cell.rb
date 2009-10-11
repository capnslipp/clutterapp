class PileRefNodeCell < NodeCell
  #cache :show, :cache_version
  
  
  def show
    super
    
    render :layout => 'pile_ref_item'
  end
  
  
protected
  
  def new_prop
    PileRefProp.new(:pile => @pile)
  end
end
