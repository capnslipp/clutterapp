class CreatePriorityProps < ActiveRecord::Migration
  def self.up
    create_table :priority_props do |t|
      t.integer :priority, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :priority_props
  end
end
