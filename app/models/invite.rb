# derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
class Invite < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  has_one :recipient, :class_name => 'User'
  
  validates_presence_of :recipient_email
  validate :recipient_is_not_registered
  validate :sender_has_invites, :if => :sender
  
  before_create :generate_token
  before_create :increment_sender_invite_sent_count, :if => :sender
  
  named_scope :sent, :conditions => 'sent_at IS NOT NULL'
  named_scope :unsent, :conditions => 'sent_at IS NULL'
  
  
  protected
  
  def recipient_is_not_registered
    errors.add :recipient_email, 'is already registered' if User.find_by_email(recipient_email)
  end
  
  
  def sender_has_invites
    unless sender.invites_remaining > 0
      errors.add_to_base 'You have reached your limit of invites to send.'
    end
  end
  
  
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
  
  
  def increment_sender_invite_sent_count
    sender.increment! :invite_sent_count
  end
  
end