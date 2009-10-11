class NoteNodeCell < NodeCell
  cache :show, :cache_version
  
  
protected
  
  def new_prop
    NoteProp.new(:pile => @pile)
  end
end
