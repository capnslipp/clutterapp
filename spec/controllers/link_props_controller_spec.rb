require 'spec_helper'

describe LinkPropsController do

  def mock_link_prop(stubs={})
    @mock_link_prop ||= mock_model(LinkProp, stubs)
  end

  describe "GET index" do
    it "assigns all link_props as @link_props" do
      LinkProp.stub(:find).with(:all).and_return([mock_link_prop])
      get :index
      assigns[:link_props].should == [mock_link_prop]
    end
  end

  describe "GET show" do
    it "assigns the requested link_prop as @link_prop" do
      LinkProp.stub(:find).with("37").and_return(mock_link_prop)
      get :show, :id => "37"
      assigns[:link_prop].should equal(mock_link_prop)
    end
  end

  describe "GET new" do
    it "assigns a new link_prop as @link_prop" do
      LinkProp.stub(:new).and_return(mock_link_prop)
      get :new
      assigns[:link_prop].should equal(mock_link_prop)
    end
  end

  describe "GET edit" do
    it "assigns the requested link_prop as @link_prop" do
      LinkProp.stub(:find).with("37").and_return(mock_link_prop)
      get :edit, :id => "37"
      assigns[:link_prop].should equal(mock_link_prop)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created link_prop as @link_prop" do
        LinkProp.stub(:new).with({'these' => 'params'}).and_return(mock_link_prop(:save => true))
        post :create, :link_prop => {:these => 'params'}
        assigns[:link_prop].should equal(mock_link_prop)
      end

      it "redirects to the created link_prop" do
        LinkProp.stub(:new).and_return(mock_link_prop(:save => true))
        post :create, :link_prop => {}
        response.should redirect_to(link_prop_url(mock_link_prop))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved link_prop as @link_prop" do
        LinkProp.stub(:new).with({'these' => 'params'}).and_return(mock_link_prop(:save => false))
        post :create, :link_prop => {:these => 'params'}
        assigns[:link_prop].should equal(mock_link_prop)
      end

      it "re-renders the 'new' template" do
        LinkProp.stub(:new).and_return(mock_link_prop(:save => false))
        post :create, :link_prop => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested link_prop" do
        LinkProp.should_receive(:find).with("37").and_return(mock_link_prop)
        mock_link_prop.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :link_prop => {:these => 'params'}
      end

      it "assigns the requested link_prop as @link_prop" do
        LinkProp.stub(:find).and_return(mock_link_prop(:update_attributes => true))
        put :update, :id => "1"
        assigns[:link_prop].should equal(mock_link_prop)
      end

      it "redirects to the link_prop" do
        LinkProp.stub(:find).and_return(mock_link_prop(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(link_prop_url(mock_link_prop))
      end
    end

    describe "with invalid params" do
      it "updates the requested link_prop" do
        LinkProp.should_receive(:find).with("37").and_return(mock_link_prop)
        mock_link_prop.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :link_prop => {:these => 'params'}
      end

      it "assigns the link_prop as @link_prop" do
        LinkProp.stub(:find).and_return(mock_link_prop(:update_attributes => false))
        put :update, :id => "1"
        assigns[:link_prop].should equal(mock_link_prop)
      end

      it "re-renders the 'edit' template" do
        LinkProp.stub(:find).and_return(mock_link_prop(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested link_prop" do
      LinkProp.should_receive(:find).with("37").and_return(mock_link_prop)
      mock_link_prop.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the link_props list" do
      LinkProp.stub(:find).and_return(mock_link_prop(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(link_props_url)
    end
  end

end
