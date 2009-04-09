class CreateTextProps < ActiveRecord::Migration
  def self.up
    create_table :text_props do |t|
      t.string :text, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :text_props
  end
end
