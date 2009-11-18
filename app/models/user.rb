require 'digest/sha1'

class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 6..40
  validates_uniqueness_of   :login

  validates_length_of       :name,     :maximum => 100
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email

  
  # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
  
  #validates_presence_of   :invite_id, :message => 'is required'
  validates_uniqueness_of :invite_id
  
  has_many :sent_invites, :class_name => 'Invite', :foreign_key => 'sender_id'
  belongs_to :invite
  
  before_create :set_starting_invite_limit
  
  
  #before_validation_on_create :create_default_pile!
  after_create :default_pile # ensures that it's created
  
  
  
  has_many :piles, :foreign_key => 'owner_id', :dependent => :destroy, :autosave => true
  
  
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :invite_token
  
  
  
  def to_param
    login
  end
  
  
  # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
  
  def invite_token
    invite.token if invite
  end
  
  
  def invite_token=(token)
    self.invite = Invite.find_by_token(token)
  end
  
  
  def invites_remaining
    if invite_limit.nil?
      (1.0/0.0) # infinity
    else
      invite_limit - invite_sent_count
    end
  end
  
  
  
  def default_pile
    @default_pile ||= piles.first || create_default_pile
  end
  
  
protected
  
  DEFAULT_INVITATION_LIMIT = (1.0/0.0) # infinity
  
  def set_starting_invite_limit
    self.invite_limit = DEFAULT_INVITATION_LIMIT
  end
  
  def create_default_pile
    @default_pile = Pile.create(:owner => self, :name => "#{self.name}'s Pile") unless piles.count > 0
  end
  
  def create_default_pile!
    raise Exception.new('A default Pile could not be created because one for this User already exists.') if piles.count > 0
    create_default_pile
  end
  
end