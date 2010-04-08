class CreateLinkProps < ActiveRecord::Migration
  def self.up
    create_table :link_props do |t|
      t.string :link, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :link_props
  end
end
