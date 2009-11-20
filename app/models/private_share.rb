class PrivateShare < Share
  belongs_to :authorized_user, :class_name => "User", :foreign_key => "user_id", :conditions => ['authorized = ?', true]
  belongs_to :shared_pile, :class_name => "Pile", :foreign_key => "shared_pile_id"
end