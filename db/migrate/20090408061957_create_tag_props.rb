class CreateTagProps < ActiveRecord::Migration
  def self.up
    create_table :tag_props do |t|
      t.string :tag, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :tag_props
  end
end
