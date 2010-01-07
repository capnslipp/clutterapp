class UsersDataset < Dataset::Base
  
  def load
    create_user :bob, {
      :login => 'bobbob',
      :email => 'bob@example.com',
      :password => '4W3S0M3',
      :password_confirmation => '4W3S0M3'
    }
    
    create_user :sal, {
      :login => 'salsal',
      :email => 'sal@example.com',
      :password => '4W3S0M3r',
      :password_confirmation => '4W3S0M3r'
    }
  end
  
  helpers do
    def create_user(dataset_name, attributes)
      dataset_name = dataset_name.to_sym
      
      u = User.create! attributes
      name_model u, dataset_name
    end
    
    def login_as(user)
      @request.session[:user_id] = user.id
    end
  end
  
end
