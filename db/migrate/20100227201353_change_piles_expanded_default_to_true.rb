class ChangePilesExpandedDefaultToTrue < ActiveRecord::Migration
  def self.up
    # switch to expanded by default (all existing Piles remain collapsed)
    change_column :piles, :expanded, :boolean, :default => true
  end

  def self.down
    # switch back to collapsed by default
    change_column :piles, :expanded, :boolean, :default => false
  end
end
