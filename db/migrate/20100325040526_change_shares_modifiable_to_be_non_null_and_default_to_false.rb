class ChangeSharesModifiableToBeNonNullAndDefaultToFalse < ActiveRecord::Migration
  def self.up
    change_column :shares, :modifiable, :bool, :null => false, :default => false
  end

  def self.down
    change_column :shares, :modifiable, :bool
  end
end
