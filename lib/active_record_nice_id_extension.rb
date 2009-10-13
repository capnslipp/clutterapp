class ActiveRecord::Base
  
  def nice_id
    if new_record?
      "new:##{self.object_id}"
    else
      "id:#{self.id}"
    end
  end
  
end