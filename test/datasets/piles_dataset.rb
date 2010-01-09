class PilesDataset < Dataset::Base
  dataset :user
  
  def load
    name_model users(:a_user).default_pile,       :a_user_default_pile
    name_model users(:another_user).default_pile, :another_user_default_pile
    
    create_pile :a_pile, {
    }
    
    create_pile :another_pile, {
    }
  end
  
  helpers do
    
    def create_pile(dataset_name, attributes)
      u = Pile.create! attributes
      name_model u, dataset_name
    end
    
  end
  
end
