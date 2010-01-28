class UsersDataset < Dataset::Base
  
  def load
    create_user :a_user, :with => {
      :login => 'a_user',
      :email => 'a_user@example.com',
      :password => 'secret',
      :password_confirmation => 'secret'
    }
    
    create_user :another_user, :with => {
      :login => 'another_user',
      :email => 'another_user@example.com',
      :password => 'secret',
      :password_confirmation => 'secret'
    }
  end
  
  helpers do
    
    def create_user(dataset_name, opts = {})
      raise ArgumentError unless opts.has_key?(:with)
      
      u = User.create! opts[:with]
      name_model u, dataset_name
    end
    
  end
  
end
