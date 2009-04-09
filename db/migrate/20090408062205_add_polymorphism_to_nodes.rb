class AddPolymorphismToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :prop_id,    :integer
    add_column :nodes, :prop_type,  :string
  end
  
  def self.down
    remove_column :nodes, :prop_type
    remove_column :nodes, :prop_id
  end
end
