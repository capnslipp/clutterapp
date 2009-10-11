class CreatePileRefProps < ActiveRecord::Migration
  def self.up
    create_table :pile_ref_props do |t|
      t.integer :ref_pile_id, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :pile_ref_props
  end
end
