class SwitchFromRootNodeHasOnePileToPileHasManyNodes < ActiveRecord::Migration
  
  def self.up
    Node.transaction do
      Pile.transaction do
        # add the new column
        add_column :nodes, :pile_id, :integer, :null => false
        
        # populate data from the old column
        Node.all.each do |n|
          n.update_attribute(:pile_id => n.root.pile.id)
        end
        
        # remove the old column
        remove_column :piles, :root_node_id
      end
    end
  end
  
  def self.down
    Node.transaction do
      Pile.transaction do
        # add the old column
        add_column :piles, :root_node_id, :integer
        
        # populate data from the new column
        Pile.all.each do |p|
          p.update_attribute(:root_node_id => p.nodes.first.root.id)
        end
        
        # remove the new column
        remove_column :nodes, :pile_id
      end
    end
  end
  
end
