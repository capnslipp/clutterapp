class AddPublicToUser < ActiveRecord::Migration
  def self.up
    add_column :shares, :public, :boolean, :default => false
  end

  def self.down
    remove_column :shares, :public
  end
end