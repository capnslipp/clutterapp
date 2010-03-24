class AddModifiableToShares < ActiveRecord::Migration
  def self.up
    add_column :shares, :modifiable, :bool
  end
  
  def self.down
    remove_column :shares, :modifiable
  end
end
