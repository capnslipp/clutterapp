class RemoveStiTypeFromNodes < ActiveRecord::Migration
  def self.up
    remove_column :nodes, :type
  end
  
  def self.down
    add_column :nodes, :type, :string
    
    Node.all.each do |n|
      n.update_attribute(:type, n.root? ? BaseNode.name : Node.name)
    end
  end
end
