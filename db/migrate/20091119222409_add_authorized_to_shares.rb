class AddAuthorizedToShares < ActiveRecord::Migration
  def self.up
    add_column :shares, :authorized, :boolean, :default => false
  end

  def self.down
    remove_column :shares, :authorized
  end
end
