class Followship < ActiveRecord::Base
  belongs_to :user
  belongs_to :followee, :class_name => "User", :foreign_key => 'followee_id'
  validates_presence_of :user_id, :followee_id
  
  def self.find_by_user_and_followee(user, followee)
    find(:first, :conditions => ["user_id = ? and followee_id = ?", user.id, followee.id])
  end
end
