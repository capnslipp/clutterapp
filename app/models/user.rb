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
  
  
  #before_validation_on_create :create_default_pile!
  after_create :default_pile # ensures that it's created
  
  #Followship associations
  has_many :followships
  has_many :followees, :through => :followships
  
  has_many :shares
  has_many :shared_piles, :through => :shares
  
  # @fix: get it to properly alias tables so that "a_user.followees.followers_of(self)" works
  named_scope :followers_of, proc {|a_user| {
      :conditions => { :followships_4_followers_of => {:followee_id => a_user.id} },
      :joins => %q{INNER JOIN `followships` as followships_4_followers_of ON followships_4_followers_of.user_id = users.id} #:joins => :followships # with "followships as followships_4_followers_of" alias
  } }
  
  
  has_many :piles, :foreign_key => 'owner_id', :dependent => :destroy, :autosave => true
  
  
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :invite_token
  
  
  
  def to_param
    login
  end
  
  #Followship methods
  
  def follow(user_to_follow)
    followship = followships.build(:followee => user_to_follow)
    
    logger.debug "User is already following #{user_to_follow.login}" unless followship.save
  end
  
  # Combining the two into the follow one above
  #def follow(user)
  #  followship = followships.build(:user_id => user.id, :followee_id => self.id)
  #  unless followship.save
  #    logger.debug "User is already following #{user.login}"
  #  end
  #end
  
  def unfollow(user_to_unfollow)
    followship = Followship.find_by_user_and_followee(self, user_to_unfollow)
    followship.destroy if followship
  end
  
  def following?(followee_user)
    self.followees.include? followee_user
  end
  
  def followed_by?(follower_user)
    self.followers.include? follower_user
  end
  
  def followers
    User.followers_of(self)
  end
  
  def friends
    followees.followers_of(self)
  end
  
  def friends_with?(another_user)
    self.friends.include? another_user
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