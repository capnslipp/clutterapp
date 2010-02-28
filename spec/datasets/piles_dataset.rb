class PilesDataset < Dataset::Base
  uses :users
  
  def load
    name_pile :slippys,
      :for => users(:slippy_douglas).root_pile
    
    create_pile :plans_to_rule_the_world, :with => {
      :name => 'Plans to Rule the World',
      :owner => users(:slippy_douglas)
    }
    
    create_pile :step_1_the_girl, :with => {
      :name => 'Step 1: The Girl',
      :owner => users(:slippy_douglas)
    }
    
    create_pile :every_day_responsibilities, :with => {
      :name => 'Every Day Responsibilities',
      :owner => users(:slippy_douglas)
    }
    
    
    name_pile :joshs,
      :for => users(:josh_vera).root_pile
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
