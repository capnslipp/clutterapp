require 'spec_helper'

describe NodesController do
  include NodesHelper
  dataset :nodes
  integrate_views
  
  
  def bypass_authentication
    NodesController.any_instance.stubs :logged_in? => true, :current_user => users(:slippy_douglas)
  end
  
  before(:each) do
    bypass_authentication
  end
  
  after(:each) do
    flash.now[:error].should be_nil
    flash.now[:warning].should be_nil
    
    assert_response :success
  end
  
  
  it "should create node" do
    assert_difference 'Node.count', +1 do
      xhr :post, :create,
        :user_id => users(:slippy_douglas).to_param,
        :pile_id => piles(:slippys).to_param,
        :node => {
          :parent_id => piles(:slippys).root_node.to_param,
          :prop_type => 'text',
          :prop_attributes => {:value => "a test node's text"}
        }
    end
  end
  
  
  it "should destroy node" do
    assert_difference 'Node.count', -1 do
      xhr :delete, :destroy,
        :user_id => users(:slippy_douglas).to_param,
        :pile_id => piles(:slippys).to_param,
        :id => nodes(:a_plain_text_node).to_param
    end
  end
  
  
  describe "new" do
    describe "should render properly" do
      
      it "given a request for a new sub-item" do
        xhr :get, :new,
          :user_id => users(:slippy_douglas).to_param,
          :pile_id => piles(:slippys).to_param,
          :node => {
            :parent_id => nodes(:a_plain_text_node).to_param,
            :prop_type => 'text'
          }
        
        response.should have_tag("input[type='text']")
      end
      
      it "given a request for a new sub-pile" do
        xhr :get, :new,
          :user_id => users(:slippy_douglas).to_param,
          :pile_id => piles(:slippys).to_param,
          :node => {
            :parent_id => nodes(:a_plain_text_node).to_param,
            :prop_type => 'pile_ref'
          }
        
        response.should have_tag("input[type='text']")
      end
      
      it "given a request for a new sub-item of a sub-pile" do
        xhr :get, :new,
          :user_id => users(:slippy_douglas).to_param,
          :pile_id => piles(:slippys).to_param,
          :node => {
            :parent_id => piles(:every_day_responsibilities).root_node.to_param,
            :prop_type => 'text'
          }
        
        response.should have_tag("input[type='text']")
      end
      
      it "given a request for a new sub-pile of a sub-pile" do
        xhr :get, :new,
          :user_id => users(:slippy_douglas).to_param,
          :pile_id => piles(:slippys).to_param,
          :node => {
            :parent_id => piles(:every_day_responsibilities).root_node.to_param,
            :prop_type => 'pile_ref'
          }
        
        response.should have_tag("input[type='text']")
      end
      
    end
  end
  
  
  describe "reparent" do
    
    describe "within the same pile" do
      
      describe "should work" do
        
        it "moving a 1st-level item to a descendent of a sibling item" do
          @n = nodes(:a_plain_text_node)
          @tn = nodes(:a_sub_sub_todo_node)
        end
        
        it "moving to a descendent item to the 1st level" do
          @n = nodes(:a_sub_sub_todo_node)
          @tn = piles(:slippys).root_node
        end
        
        after(:each) do
          xhr :put, :reparent, :user_id => @n.pile.owner.to_param, :pile_id => @n.pile.to_param, :id => @n.to_param, :target_id => @tn.to_param, :target_pile_id => @tn.pile.to_param
          response.should be_success
        end
        
      end
      
      describe "should not work" do
        it "moving a 1st-level item to a descendent of itself" do
          @n = nodes(:a_todo_node)
          @tn = nodes(:a_sub_sub_todo_node)
        end
        
        after(:each) do
          proc {
            xhr :put, :reparent, :user_id => @n.pile.owner.to_param, :pile_id => @n.pile.to_param, :id => @n.to_param, :target_id => @tn.to_param, :target_pile_id => @tn.pile.to_param
          }.should raise_error(ActiveRecord::ActiveRecordError)
        end
        
      end
      
    end # within the same pile
    
    describe "from one pile to another" do
      
      describe "should work" do
        it "moving a 1st-level item to the 1st level of a sub-Pile" do
          @n = nodes(:a_plain_text_node)
          @tn = piles(:plans_to_rule_the_world).root_node
        end
        
        it "moving a descendent item to the 1st level of a sub-Pile" do
          @n = nodes(:a_sub_sub_todo_node)
          @tn = piles(:plans_to_rule_the_world).root_node
        end
        
        it "moving a the 1st level sub-Pile to the 1st level of a sub-Pile" do
          @n = nodes(:resposiblities_sub_pile_ref_node)
          @tn = piles(:plans_to_rule_the_world).root_node
        end
        
        it "moving a 1st-level item to the 1st level of a parent Pile" do
          @n = nodes(:plans_to_rule_the_world_desc_node)
          @tn = piles(:slippys).root_node
        end
        
        it "moving a 1st-level item to descendent item of a parent Pile" do
          @n = nodes(:plans_to_rule_the_world_desc_node)
          @tn = nodes(:a_sub_sub_todo_node)
        end
        
        it "moving a 1st-level sub-Pile to the 1st level of a parent Pile" do
          @n = nodes(:step_1_sub_pile_ref_node)
          @tn = piles(:slippys).root_node
        end
        
        after(:each) do
          xhr :put, :reparent, :user_id => @n.pile.owner.to_param, :pile_id => @n.pile.to_param, :id => @n.to_param, :target_id => @tn.to_param, :target_pile_id => @tn.pile.to_param
          response.should be_success
        end
        
      end
      
    end # from one pile to another
    
  end # reparent
  
  
end
