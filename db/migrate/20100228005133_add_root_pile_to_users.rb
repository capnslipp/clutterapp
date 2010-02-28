class AddRootPileToUsers < ActiveRecord::Migration
  def self.up
    # allowing NULL because otherwise this makes validation during creation a PitA
    add_column :users, :root_pile_id, :integer
    
    # add the column before starting the transaction
    User.all.each do |u|
      u.send :build_root_pile
      u.send :save_root_pile!
    end
  end
  
  def self.down
    remove_column :users, :root_pile_id
  end
end
