class AddInviteToUsers < ActiveRecord::Migration
  
  def self.up
    add_column :users, :invite_id,          :integer, :null => false
    add_column :users, :invite_limit,       :integer
    add_column :users, :invite_sent_count,  :integer, :null => false, :default => 0
  end
  
  
  def self.down
    remove_column :users, :invite_sent_count
    remove_column :users, :invite_limit
    remove_column :users, :invite_id
  end
  
end