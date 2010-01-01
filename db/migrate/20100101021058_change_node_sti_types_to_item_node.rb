class ChangeNodeStiTypesToItemNode < ActiveRecord::Migration
  def self.up
    Node.all.reject {|n| n.is_a? BaseNode }.each do |n|
      n.update_attribute(:type, ItemNode.name)
    end
  end

  def self.down
    ItemNode.all.each do |n|
      n.update_attribute(:type, Node.name)
    end
  end
end
