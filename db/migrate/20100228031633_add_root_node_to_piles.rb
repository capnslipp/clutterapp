class AddRootNodeToPiles < ActiveRecord::Migration
  def self.up
    # allowing NULL because otherwise this makes validation during creation a PitA
    add_column :piles, :root_node_id, :integer
    
    # add the column before starting the transaction
    Pile.all.each do |p|
      p.update_attribute(:root_node_id, p.nodes.first.root.id)
    end
  end
  
  def self.down
    remove_column :piles, :root_node_id
  end
end
