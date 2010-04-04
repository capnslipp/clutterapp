class UsersDataset < Dataset::Base
  
  def load
    create_user :slippy_douglas, :with => {
      :login => 'slippy_douglas',
      :email => 'slippy_douglas@example.com',
      :password => 'secret',
      :password_confirmation => 'secret'
    }
    
    create_user :josh_vera, :with => {
      :login => 'josh_vera',
      :email => 'josh_vera@example.com',
      :password => 'secret',
      :password_confirmation => 'secret'
    }
  end
  
  helpers do
    
    def create_user(dataset_name, opts = {})
      raise ArgumentError.new ":with option is required" unless opts.has_key?(:with)
      
      u = User.create! opts[:with]
      name_model u, dataset_name
    end
    
  end
  
end
