class PilesDataset < Dataset::Base
  uses :users
  
  def load
    name_pile :a_users_default_pile,
      :for => users(:a_user).default_pile
    
    create_pile :a_pile, :with => {
      :name => 'A Pile',
      :owner => users(:a_user)
    }
    
    create_pile :a_better_pile, :with => {
      :name => 'A Better Pile',
      :owner => users(:a_user)
    }
    
    
    name_pile :another_users_default_pile,
      :for => users(:another_user).default_pile
    
    create_pile :another_pile, :with => {
      :name => 'Another Pile',
      :owner => users(:another_user)
    }
  end
  
  helpers do
    
    def create_pile(dataset_name, opts = {})
      u = Pile.create! opts[:with]
      name_model u, dataset_name
    end
    
    def name_pile(dataset_name, opts = {})
      name_model opts[:for], dataset_name
    end
    
  end
  
end
