class AddPositionToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :position, :integer
    add_index :nodes, :position
  end
  
  def self.down
    remove_index :nodes, :position
    remove_column :nodes, :position
  end
end
