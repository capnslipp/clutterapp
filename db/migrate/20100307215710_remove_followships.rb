class RemoveFollowships < ActiveRecord::Migration
  
  def self.up
    drop_table :followships
  end
  
  def self.down
    create_table :followships do |t|
      t.integer :user_id
      t.integer :followee_id
      
      t.timestamps
    end
  end
  
end
