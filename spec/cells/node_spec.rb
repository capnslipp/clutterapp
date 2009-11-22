require 'spec_helper'



=begin
  Helper Module
=end

module NodeSpecHelper
  
  def mock_node(stubs={})
    @mock_node ||= mock_model(
      Node,
      {
        :pile => mock_model(Pile, :owner => mock_model(User)),
        :children => mock(Array, :typed => [], :empty? => true),
        :parent_id => 2600
      }.merge(stubs)
    )
  end
  
end



=begin
  Base NodeCell Specs
=end

describe NodeCell do
  integrate_views
  include NodeSpecHelper
  
  before(:each) do
    mock_node :prop => mock_model(Prop)
  end
  
  describe "show action" do
    it "doesn't work" do
      proc {
        @result = render_cell(:show, :node => @mock_node)
      }.should raise_error(ActionView::MissingTemplate)
    end
  end
  
  describe "edit action" do
    it "doesn't work" do
      proc {
        @result = render_cell(:edit, :node => @mock_node)
      }.should raise_error(ActionView::MissingTemplate)
    end
  end
  
end



=begin
  Shared Examples
=end

share_examples_for "All NodeCells" do
  integrate_views
  include NodeSpecHelper
  
  after(:each) do
    opts[:node].should be(@mock_node)
    @result.should_not be_blank
  end
  
end


share_examples_for "Showing a NodeCell" do
  it("works") { @result = render_cell(:show, :node => @mock_node) }
end

share_examples_for "(NYI) Showing a NodeCell" do
  it "works"
end

share_examples_for "Editing a NodeCell" do
  it("works") { @result = render_cell(:edit, :node => @mock_node) }
end

share_examples_for "(NYI) Editing a NodeCell" do
  it "works"
end

share_examples_for "Newing a NodeCell" do
  it("works") { @result = render_cell(:new, :node => @mock_node) }
end

share_examples_for "(NYI) Newing a NodeCell" do
  it "works"
end



=begin
  NodeCell Variant Specs
=end

describe CheckNodeCell do
  it_should_behave_like "All NodeCells"
  
  before(:each) do
    mock_node :prop => mock_model(CheckProp, :checked? => false)
    @mock_node.prop.should_receive(:badged?).and_return(false)
    CheckProp.stub!(:to_s).with(anything).and_return('check') # @fix: not working; probably due to overriding to_s
  end
  
  describe("show action") { it_should_behave_like "Showing a NodeCell" }
  
  describe "form-based" do
    describe("edit action") { it_should_behave_like "Editing a NodeCell" }
    describe("new action") { it_should_behave_like "(NYI) Newing a NodeCell" }
  end
  
  after(:each) do
    @result.should have_tag('input[type=checkbox]')
  end
end


describe NoteNodeCell do
  it_should_behave_like "All NodeCells"
  
  before(:each) do
    mock_node :prop => mock_model(NoteProp, :note => 'A test note for >> you.')
  end
  
  describe("show action") { it_should_behave_like "Showing a NodeCell" }
  
  describe "form-based" do
    describe("edit action") { it_should_behave_like "Editing a NodeCell" }
    describe("new action") { it_should_behave_like "(NYI) Newing a NodeCell" }
    
    after(:each) { @result.should have_tag('textarea') }
  end
  
  after(:each) do
    # @fix: Doesn't work via testing for some reason.
    #@result.should include('A test note for &gt;&gt; you.') # make sure HTML escaping is being done
  end
end


describe PileRefNodeCell do
  it_should_behave_like "All NodeCells"
  
  before(:each) do
    mock_node :prop => mock_model(PileRefProp, :ref_pile => mock_model(Pile))
    @mock_node.prop.ref_pile.should_receive(:name).and_return("A Test Ref'd Pile & Stuff")
    @mock_node.prop.ref_pile.stub(:owner).and_return(mock_model(User))
    @mock_node.prop.ref_pile.should_receive(:root_node).at_least(:once).and_return(mock_model(Node))
    @mock_node.prop.ref_pile.root_node.stub(:children).and_return([])
  end
  
  describe("show action") { it_should_behave_like "Showing a NodeCell" }
  
  describe "form-based" do
    describe("edit action") { it_should_behave_like "(NYI) Editing a NodeCell" }
    describe("new action") { it_should_behave_like "(NYI) Newing a NodeCell" }
    
    #after(:each) {  @result.should have_tag('input[type=text]') }
  end
  
  after(:each) do
    @result.should have_tag('section')
    @result.should include("A Test Ref'd Pile &amp; Stuff") # make sure HTML escaping is being done
  end
end


describe PriorityNodeCell do
  it_should_behave_like "All NodeCells"
  
  before(:each) do
    mock_node :prop => mock_model(PriorityProp, :priority => 110000000000)
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
  
  describe("show action") { it_should_behave_like "Showing a NodeCell" }
  
  describe "form-based" do
    describe("edit action") { it_should_behave_like "Editing a NodeCell" }
    describe("new action") { it_should_behave_like "(NYI) Newing a NodeCell" }
    
    after(:each) { @result.should have_tag('input[type=text]') }
  end
  
  after(:each) do
    # @fix: Doesn't work via testing for some reason.
    #@result.should include('110000000000')
  end
end


describe TagNodeCell do
  it_should_behave_like "All NodeCells"
  
  before(:each) do
    mock_node :prop => mock_model(TagProp, :tag => 'test-tag')
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
  
  describe("show action") { it_should_behave_like "Showing a NodeCell" }
  
  describe "form-based" do
    describe("edit action") { it_should_behave_like "Editing a NodeCell" }
    describe("new action") { it_should_behave_like "(NYI) Newing a NodeCell" }
    
    after(:each) { @result.should have_tag('input[type=text]') }
  end
  
  after(:each) do
    # @fix: Doesn't work via testing for some reason.
    #@result.should include('test-tag')
  end
end


describe TextNodeCell do
  it_should_behave_like "All NodeCells"
  
  before(:each) do
    mock_node :prop => mock_model(TextProp, :text => 'test text')
  end
  
  describe("show action") { it_should_behave_like "Showing a NodeCell" }
  
  describe "form-based" do
    describe("edit action") { it_should_behave_like "Editing a NodeCell" }
    describe("new action") { it_should_behave_like "(NYI) Newing a NodeCell" }
    
    after(:each) { @result.should have_tag('input[type=text]') }
  end
  
  after(:each) do
    # @fix: Doesn't work via testing for some reason.
    #@result.should include('test text')
  end
end


describe TimeNodeCell do
  it_should_behave_like "All NodeCells"
  
  before(:each) do
    @time_now = Time.now
    
    mock_node :prop => mock_model(TimeProp, :time => @time_now)
    @mock_node.prop.should_receive(:badged?).and_return(false)
  end
  
  describe("show action") { it_should_behave_like "Showing a NodeCell" }
  
  describe "form-based" do
    describe("edit action") { it_should_behave_like "Editing a NodeCell" }
    describe("new action") { it_should_behave_like "(NYI) Newing a NodeCell" }
    
    after(:each) { @result.should have_tag('input[type=text]') }
  end
  
  after(:each) do
    # @fix: Doesn't work via testing for some reason.
    #@result.should include(@time_now.to_s)
  end
end
