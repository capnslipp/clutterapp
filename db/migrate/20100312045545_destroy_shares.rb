class DestroyShares < ActiveRecord::Migration
  def self.up
    drop_table :shares
  end
  
  def self.down
    create_table :shares do |t|
      t.integer  :sharee_id
      t.integer  :pile_id
      t.timestamps
      t.boolean  :authorized, :default => false
      t.boolean  :public,     :default => false
    end
  end
end
