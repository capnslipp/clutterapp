class AddRootNodeToPiles < ActiveRecord::Migration
  def self.up
    # allowing NULL because otherwise this makes validation during creation a PitA
    add_column :piles, :root_node_id, :integer
    
    # add the column before starting the transaction
    Pile.all.each do |p|
      p.update_attributes!(:root_node => p.nodes.first.root)
    end
  end
  
  def self.down
    remove_column :piles, :root_node_id
  end
end
