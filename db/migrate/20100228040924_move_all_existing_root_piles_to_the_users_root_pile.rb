class MoveAllExistingRootPilesToTheUsersRootPile < ActiveRecord::Migration
  def self.up
    User.all.each do |u|
      
      existing_root_piles = u.piles
      
      # reject the new root pile that will parent all the existing ones
      existing_root_piles = existing_root_piles.reject do |p|
        p == u.root_pile
      end
            
      # reject the non-root piles
      existing_root_piles = existing_root_piles.reject do |p|
        p.pile_ref_prop
      end
      
      # add PileRefs for each of them
      existing_root_piles.each do |p|
        Node.create! :parent => u.root_pile.root_node, :prop => PileRefProp.new(:ref_pile => p)
      end
      
    end
  end
  
  def self.down
    User.all.each do |u|
      
      root_pile_sub_piles = u.piles
            
      # select piles that are referenced by pile-refs in the root pile
      root_pile_sub_piles = root_pile_sub_piles.select do |p|
        p.pile_ref_prop && p.pile_ref_prop.node.pile == u.root_pile
      end
      
      # add PileRefs for each of them
      root_pile_sub_piles.each do |p|
        p.pile_ref_prop.node.delete
        p.pile_ref_prop.delete
      end
      
    end
  end
end
