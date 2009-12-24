class MakeNodesPropNotNull < ActiveRecord::Migration
  def self.up
    Node.transaction do
      Node.destroy_all :prop_id => nil
      Node.destroy_all :prop_type => nil
      
      change_column :nodes, :prop_id,   :integer, :null => false
      change_column :nodes, :prop_type, :integer, :null => false
      
    end
  end

  def self.down
    Node.transaction do
      
      change_column :nodes, :prop_id,   :integer, :null => true
      change_column :nodes, :prop_type, :integer, :null => true
      
    end
  end
end
