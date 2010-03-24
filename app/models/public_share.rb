class PublicShare < Share
  validates_uniqueness_of :pile_id
  
end
