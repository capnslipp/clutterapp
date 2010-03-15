class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 6..40
  validates_uniqueness_of   :login,    :message => %<"{{value}}" has already been taken>
  
  validates_length_of       :name,     :maximum => 100
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :message => %<"{{value}}" has already been taken>
  
  
  # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
  
  #validates_presence_of   :invite_id, :message => 'is required'
  validates_uniqueness_of :invite_id, :allow_nil => true
  
  has_many :sent_invites, :class_name => 'Invite', :foreign_key => 'sender_id'
  belongs_to :invite
  
  before_create :set_starting_invite_limit
  
  
  # Piles associations
  has_many :piles,        :dependent => :destroy, :foreign_key => 'owner_id'
  
  belongs_to :root_pile,  :dependent => :destroy, :class_name => Pile.name
  before_validation_on_create :build_root_pile
  after_create :save_root_pile!
  
  
  # Share associations
  
  has_many :shares, :through => :piles
  
  
  # HACK HACK HACK -- how to do attr_accessible from here? Prevents a user from submitting a crafted form that bypasses activation anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :invite_token, :root_pile, :root_pile_id
  
  
  
  def to_param
    login
  end
  
  
  # validating setters and utils
  
  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end
  
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  
  def invite_limit=(value)
    write_attribute :invite_limit, (value && value.infinite? ? nil : value)
  end
  
  
  def has_name?
    !attributes['name'].blank?
  end
  
  
  def name
    return attributes['name'] unless attributes['name'].blank?
    return attributes['login']
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
  
  
  
  # Method to send reset password
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  
protected
  
  DEFAULT_INVITATION_LIMIT = (1.0/0.0) # infinity
  
  def set_starting_invite_limit
    self.invite_limit = DEFAULT_INVITATION_LIMIT
  end
  
  def build_root_pile
    if self.root_pile
      logger.warn %[build_root_pile attempted for User##{self.id} "#{self.login}" when one already exists]
      return
    end
    
    self.root_pile = Pile.new(:name => %[<#{self.login}'s root pile>])
  end
  
  def save_root_pile!
    self.root_pile.owner = self # setting owner afterwards is necessary during creation
    self.root_pile.save!
    self.save!
  end
end