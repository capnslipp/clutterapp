class CreateFollowships < ActiveRecord::Migration
  def self.up
    create_table :followships do |t|
      t.integer :user_id
      t.integer :followee_id

      t.timestamps
    end
  end

  def self.down
    drop_table :followships
  end
end
