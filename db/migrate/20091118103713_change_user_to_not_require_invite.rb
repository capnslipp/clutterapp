class ChangeUserToNotRequireInvite < ActiveRecord::Migration
  def self.up
    change_column :users, :invite_id, :integer, :null => true # allow either way
  end
  
  def self.down
    change_column :users, :invite_id, :integer, :null => false
  end
end
