class CreateTimeProps < ActiveRecord::Migration
  def self.up
    create_table :time_props do |t|
      t.datetime :time, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :time_props
  end
end
