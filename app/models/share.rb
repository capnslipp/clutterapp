class Share < ActiveRecord::Base
  belongs_to :pile
  validates_presence_of :pile
  
  belongs_to :sharee, :class_name => User.name
  validate(:sharee_present) { !public? }
  validate(:sharee_absent) { public? }
  validates_uniqueness_of :sharee, :scope => 'pile_id' # share each pile with each "sharee" User at most once
  
  validate(:not_authorized) { public? }
  
  
  protected
  
  def sharee_present(&condition)
    if condition.call
      errors.add(:sharee, "must be present") unless sharee.present?
    end
  end
  
  def sharee_absent(&condition)
    if condition.call
      errors.add(:sharee, "must be absent") unless sharee.empty?
    end
  end
  
  def not_authorized(&condition)
    if condition.call
      errors.add(:authorized, "must be off") unless !authorized
    end
  end
  
end
