class CreatePiles < ActiveRecord::Migration
  def self.up
    create_table :piles do |t|
      t.integer :owner_id
      t.integer :root_node_id
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :piles
  end
end
