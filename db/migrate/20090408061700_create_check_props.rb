class CreateCheckProps < ActiveRecord::Migration
  def self.up
    create_table :check_props do |t|
      t.boolean :checked, :default => false, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :check_props
  end
end
