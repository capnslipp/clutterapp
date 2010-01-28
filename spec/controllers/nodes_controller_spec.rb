require 'spec_helper'

describe NodesController do
  include NodesHelper
  dataset :nodes
  integrate_views
  
  
  def bypass_authentication
    NodesController.any_instance.stubs :logged_in? => true, :current_user => users(:a_user)
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
        :user_id => users(:a_user).to_param,
        :pile_id => piles(:a_pile).to_param,
        :node => {
          :parent_id => nodes(:a_piles_root_node).to_param,
          :prop_type => 'text',
          :prop_attributes => {:value => "a test node's text"}
        }
    end
  end
  
  
  it "should destroy node" do
    assert_difference 'Node.count', -1 do
      xhr :delete, :destroy,
        :user_id => users(:a_user).to_param,
        :pile_id => piles(:a_pile).to_param,
        :id => nodes(:a_plain_text_node).to_param
    end
  end
  
  
  describe "new" do
    describe "should render properly" do
      
      it "given a request for a new sub-item" do
        xhr :get, :new,
          :user_id => users(:a_user).to_param,
          :pile_id => piles(:a_pile).to_param,
          :node => {
            :parent_id => nodes(:a_plain_text_node).to_param,
            :prop_type => 'text'
          }
        
        response.should have_tag("input[type='text']")
      end
      
      it "given a request for a new sub-pile" do
        xhr :get, :new,
          :user_id => users(:a_user).to_param,
          :pile_id => piles(:a_pile).to_param,
          :node => {
            :parent_id => nodes(:a_plain_text_node).to_param,
            :prop_type => 'pile-ref'
          }
        
        response.should have_tag("input[type='text']")
      end
      
    end
  end
  
  
end
