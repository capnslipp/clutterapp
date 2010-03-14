class RecreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.string :type
      
      # common attributes
      t.integer :pile_id
      t.timestamps
      
      # attributes for type=PublicShare
      # -- none --
      
      # attributes for type=SpecificUserShare
      t.integer :sharee_id
    end
  end

  def self.down
    drop_table :shares
  end
end
