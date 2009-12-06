class RenameSharedPileToPileInShares < ActiveRecord::Migration
  def self.up
    rename_column :shares, :shared_pile_id, :pile_id
  end

  def self.down
   rename_column :shares, :pile_id, :shared_pile_id
  end
end