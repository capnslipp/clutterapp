class AddNameToPiles < ActiveRecord::Migration
  def self.up
    Pile.transaction do
      # add the new column, disallowing a null name
      add_column :piles, :name, :string, :limit => 100
      
      # set all existing names to a safe default
      Pile.all.each do |n|
        n.update_attribute(:name, "Nondescript Pile ##{n.id}")
      end
      
      # change the new column to disallow a null name
      change_column :piles, :name, :string, :limit => 100, :null => false
    end
  end

  def self.down
    remove_column :piles, :name
  end
end
