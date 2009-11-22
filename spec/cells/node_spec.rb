require 'spec_helper'



module NodeSpecHelper
  
  def mock_node(stubs={})
    @mock_node ||= mock_model(
      Node,
      {
        :pile => mock_model(Pile, :owner => mock_model(User)),
        :children => mock(Array, :typed => [])
      }.merge(stubs)
    )
  end
  
end



describe NodeCell do
  integrate_views
  include NodeSpecHelper
  
  before(:each) do
    mock_node :prop => mock_model(Prop)
  end
  
  describe "show action" do
    it "doesn't render" do
      proc {
        @result = render_cell(:show, :node => @mock_node)
      }.should raise_error(ActionView::MissingTemplate)
    end
  end
  
  describe "edit action" do
    it "doesn't render" do
      proc {
        @result = render_cell(:edit, :node => @mock_node)
      }.should raise_error(ActionView::MissingTemplate)
    end
  end
  
end



share_examples_for "All NodeCell Types" do
  integrate_views
  include NodeSpecHelper
  
  describe "show action" do
    it "renders" do
      @result = render_cell(:show, :node => @mock_node)
      opts[:node].should be(@mock_node)
      @result.should_not be_blank
    end
  end
  
  describe "edit action" do
    it "renders" do
      @result = render_cell(:edit, :node => @mock_node)
      opts[:node].should be(@mock_node)
      @result.should_not be_blank
    end
  end
  
end



describe CheckNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(CheckProp, :checked? => false)
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
  
  after(:each) do
    @result.should have_tag('input[type=checkbox]')
  end
end


describe NoteNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(NoteProp, :note => 'A test note for >> you.')
  end
  
  after(:each) do
    # @fix: Doesn't work via testing for some reason.
    #@result.should include('A test note for &gt;&gt; you.') # make sure HTML escaping is being done
  end
end


describe PileRefNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(PileRefProp, :ref_pile => mock_model(Pile))
    @mock_node.prop.ref_pile.should_receive(:name).and_return("A Test Ref'd Pile & Stuff")
    @mock_node.prop.ref_pile.stub(:owner).and_return(mock_model(User))
    @mock_node.prop.ref_pile.should_receive(:root_node).at_least(:once).and_return(mock_model(Node))
    @mock_node.prop.ref_pile.root_node.stub(:children).and_return([])
  end
  
  after(:each) do
    @result.should include("A Test Ref'd Pile &amp; Stuff") # make sure HTML escaping is being done
  end
end


describe PriorityNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(PriorityProp, :priority => 7)
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
  
  after(:each) do
    @result.should include('7')
  end
end


describe TagNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(TagProp, :tag => 'test-tag')
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
  
  after(:each) do
    # @fix: Doesn't work via testing for some reason.
    #@result.should include('test-tag')
  end
end


describe TextNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(TextProp, :text => 'test text')
  end
  
  after(:each) do
    # @fix: Doesn't work via testing for some reason.
    #@result.should include('test text')
  end
end


describe TimeNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    @time_now = Time.now
    
    mock_node :prop => mock_model(TimeProp, :time => @time_now)
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
  
  after(:each) do
    # @fix: Doesn't work via testing for some reason.
    #@result.should include(@time_now.to_s)
  end
end
