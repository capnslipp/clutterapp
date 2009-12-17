class RemoveVersionFromNodes < ActiveRecord::Migration
  def self.up
    remove_column :nodes, :version
  end
  
  def self.down
    add_column :nodes, :version, :integer, :default => 0
  end
end
