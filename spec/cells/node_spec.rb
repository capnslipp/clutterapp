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
  
  describe "show" do
    it "doesn't render" do
      proc {
        @result = render_cell(:show, :node => @mock_node)
      }.should raise_error(ActionView::MissingTemplate)
    end
  end
end



share_examples_for "All NodeCell Types" do
  integrate_views
  include NodeSpecHelper
  
  describe "show" do
    it "renders" do
      @result = render_cell(:show, :node => @mock_node)
      opts[:node].should be(@mock_node)
      @result.should_not be_blank
    end
  end
end


describe CheckNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(CheckProp)
    @mock_node.prop.should_receive(:checked?).and_return(false)
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
end


describe NoteNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(NoteProp)
    @mock_node.prop.should_receive(:note).and_return('A test note.')
  end
end


describe PileRefNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(PileRefProp)
    @mock_node.prop.should_receive(:ref_pile).at_least(:once).and_return(mock_model(Pile))
    @mock_node.prop.ref_pile.should_receive(:name).and_return("A Test Ref'd Pile")
    @mock_node.prop.ref_pile.should_receive(:owner).and_return(mock_model(User))
    @mock_node.prop.ref_pile.should_receive(:root_node).at_least(:once).and_return(mock_model(Node))
    @mock_node.prop.ref_pile.root_node.should_receive(:children).and_return([])
  end
end


describe PriorityNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(PriorityProp)
    @mock_node.prop.should_receive(:priority).at_least(:once).and_return(3)
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
end


describe TagNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(TagProp)
    @mock_node.prop.should_receive(:tag).and_return('test-tag')
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
end


describe TextNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(TextProp)
    @mock_node.prop.should_receive(:text).and_return('test text')
  end
end


describe TimeNodeCell do
  it_should_behave_like "All NodeCell Types"
  
  before(:each) do
    mock_node :prop => mock_model(TimeProp)
    @mock_node.prop.should_receive(:time).and_return(Time.now)
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
end
