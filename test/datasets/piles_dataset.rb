class PilesDataset < Dataset::Base
  uses :users
  
  def load
    name_model users(:a_user).default_pile,       :a_user_default_pile
    name_model users(:another_user).default_pile, :another_user_default_pile
    
    create_pile :a_pile, {
      :name => 'A Pile',
      :owner => users(:a_user)
    }
    
    create_pile :another_pile, {
      :name => 'Another Pile',
      :owner => users(:another_user)
    }
  end
  
  helpers do
    
    def create_pile(dataset_name, attributes)
      u = Pile.create! attributes
      name_model u, dataset_name
    end
    
  end
  
end
