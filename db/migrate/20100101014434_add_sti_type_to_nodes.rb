class AddStiTypeToNodes < ActiveRecord::Migration
  def self.up
    Node.transaction do
      # add the new column, allowing null for now
      add_column :nodes, :type, :string
      
      # set all existing names to a safe default
      Node.all.each do |n|
        n.update_attribute(:type, n.root? ? BaseNode.name : Node.name)
      end
      
      # change the new column to disallow a null name
      change_column :nodes, :type, :string, :null => false
    end
  end

  def self.down
    remove_column :nodes, :type
  end
end
