class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer   :sender_id
      t.string    :recipient_email, :null => false
      t.string    :token,           :null => false
      t.datetime  :sent_at
      t.timestamps                  :null => false
    end
  end
  
  def self.down
    drop_table :invites
  end
end
