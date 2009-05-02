class AddVersionToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :version, :integer, :default => 0
  end

  def self.down
    remove_column :nodes, :version
  end
end
