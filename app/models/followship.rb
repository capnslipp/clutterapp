class Followship < ActiveRecord::Base
  belongs_to :user
  belongs_to :followee, :class_name => "User"
  validates_uniqueness_of :followee_id, :scope => :user_id
  validates_presence_of :user_id, :followee_id
  
  def self.find_by_user_and_followee(user, followee)
    find(:first, :conditions => ["user_id = ? and followee_id = ?", user.id, followee.id])
  end
end
