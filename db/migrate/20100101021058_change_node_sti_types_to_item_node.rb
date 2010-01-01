class ChangeNodeStiTypesToItemNode < ActiveRecord::Migration
  def self.up
    Node.all.reject {|n| n.is_a? BaseNode }.each do |n|
      n.update_attribute(:type, ItemNode.name)
    end
  end

  def self.down
    # first, load up the Node model/table so that ItemNode.all works (not sure why Rails doesn't auto-load this)
    Node.all
    
    ItemNode.all.each do |n|
      n.update_attribute(:type, Node.name)
    end
  end
end
