class AddExpandedToPiles < ActiveRecord::Migration
  def self.up
    add_column :piles, :expanded, :boolean, :default => false
  end
  
  def self.down
    remove_column :piles, :expanded
  end
end
