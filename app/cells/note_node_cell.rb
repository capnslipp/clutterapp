class NoteNodeCell < NodeCell
  
protected
  
  def new_prop
    NoteProp.new(:pile => @pile)
  end
end
