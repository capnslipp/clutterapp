class UsersDataset < Dataset::Base
  
  def load
    create_user :a_user, {
      :login => 'a_user',
      :email => 'a_user@example.com',
      :password => 'secret',
      :password_confirmation => 'secret'
    }
    
    create_user :another_user, {
      :login => 'another_user',
      :email => 'another_user@example.com',
      :password => 'secret',
      :password_confirmation => 'secret'
    }
  end
  
  helpers do
    
    def create_user(dataset_name, attributes)
      u = User.create! attributes
      name_model u, dataset_name
    end
    
  end
  
end
