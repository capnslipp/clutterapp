class RenameUserToShareeInShares < ActiveRecord::Migration
  def self.up
    rename_column :shares, :user_id, :sharee_id
  end

  def self.down
   rename_column :shares, :sharee_id, :user_id
  end
end
