class PublicShare < Share
  belongs_to :user
  belongs_to :shared_pile, :class_name => "Pile", :foreign_key => "shared_pile_id"
end
