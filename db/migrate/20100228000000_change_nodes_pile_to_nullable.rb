class ChangeNodesPileToNullable < ActiveRecord::Migration
  def self.up
    # allowing NULL because otherwise this makes validation during creation a PitA
    change_column :nodes, :pile_id, :integer, :null => true
  end

  def self.down
    change_column :nodes, :pile_id, :integer, :null => false
  end
end
