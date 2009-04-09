class CreateNoteProps < ActiveRecord::Migration
  def self.up
    create_table :note_props do |t|
      t.text :note, :default => '', :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :note_props
  end
end
