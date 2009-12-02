require 'spec_helper'

=begin
  Helper Module
=end

module NodeSpecHelper
  
  def mocked_node_children_empty
    unless @mocked_node_children_empty
      @mocked_node_children_empty = []
      @mocked_node_children_empty.stubs(
        :typed => [],
        :badgeable => [],
        :non_badgeable => []
      )
    end
    
    @mocked_node_children_empty
  end
  
  def mocked_node_children_with_filler_nodes
    unless @mocked_node_children_with_filler_nodes
      @mocked_node_children_with_filler_nodes = []
      @mocked_node_children_with_filler_nodes.stubs(
        :typed => Prop.types.collect {|t| Node.new(:prop => t.rand_new) },
        :badgeable => Prop.badgeable_types.collect {|t| Node.new(:prop => t.rand_new) },
        :non_badgeable => Prop.non_badgeable_types.collect {|t| Node.new(:prop => t.rand_new) }
      )
    end
    
    @mocked_node_children_with_filler_nodes
  end
  
  def mock_node(stubs={})
    @mock_node ||= mock_model(
      Node,
      {
        :pile => mock_model(Pile, :owner => mock_model(User)),
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
  
  before(:all) { @mocked_node_children = mocked_node_children_empty }
  
  before(:each) do
    mock_node(:prop => mock_model(Prop), :children => @mocked_node_children)
  end
  
  describe "show action" do
    it "raises an error (since it's the base class)" do
      proc {
        @result = render_cell(:show, :node => @mock_node)
      }.should raise_error(ActionView::MissingTemplate)
    end
  end
  
  describe "edit action" do
    it "raises an error (since it's the base class)" do
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
  
  before(:all) { @mocked_node_children = mocked_node_children_empty }
  
  after(:each) do
    opts[:node].should be(@mock_node)
    @result.should_not be_blank
  end
  
end


share_examples_for "Showing a NodeCell" do
  it("runs the state and renders valid output") { @result = render_cell(:show, :node => @mock_node) }
  
  after(:each) do
    @result.should have_tag('*[class*=show][class*=body]')
    @result.should have_tag('*[class*=show][class*=prop]')
  end
end

share_examples_for "(NYI) Showing a NodeCell" do
  it("runs the state and renders valid output")
end

share_examples_for "Editing a NodeCell" do
  it("runs the state and renders valid output") { @result = render_cell(:edit, :node => @mock_node) }
  
  after(:each) do
    @result.should have_tag('*[class*=edit][class*=body]')
    @result.should have_tag('*[class*=edit][class*=prop]')
  end
end

share_examples_for "(NYI) Editing a NodeCell" do
  it("runs the state and renders valid output")
end

share_examples_for "Newing a NodeCell" do
  it("runs the state and renders valid output") { @result = render_cell(:new, :node => @mock_node) }
  
  after(:each) do
    @result.should have_tag('*[class*=new][class*=body]')
    @result.should have_tag('*[class*=new][class*=prop]')
  end
end

share_examples_for "(NYI) Newing a NodeCell" do
  it("runs the state and renders valid output")
end



=begin
  NodeCell Variant (via NodeBodyCell) Specs
=end


describe NodeBodyCell do
  
  
  describe 'leading to', CheckNodeCell do
    it_should_behave_like "All NodeCells"
    
    before(:each) do
      mock_node(
        :prop => mock_model(CheckProp, :checked? => false, :badged? => CheckProp::badgeable?),
        :children => @mocked_node_childre
      )
      @mock_node.prop.stubs(:class => CheckProp)
    end
    
    describe("show action") { it_should_behave_like "Showing a NodeCell" }
    
    describe "form-based" do
      describe("edit action") { it_should_behave_like "(NYI) Editing a NodeCell" }
      describe("new action") { it_should_behave_like "(NYI) Newing a NodeCell" }
    end
    
    after(:each) do
      @result.should have_tag('input[type=checkbox]')
    end
  end
  
  
  describe 'leading to', NoteNodeCell do
    it_should_behave_like "All NodeCells"
    
    before(:each) do
      mock_node(
        :prop => mock_model(NoteProp, :note => 'A test note for >> you.', :badged? => NoteProp::badgeable?),
        :children => @mocked_node_children
      )
      @mock_node.prop.stubs(:class => NoteProp)
    end
    
    describe("show action") { it_should_behave_like "Showing a NodeCell" }
    
    describe "form-based" do
      describe("edit action") { it_should_behave_like "Editing a NodeCell" }
      describe("new action") { it_should_behave_like "Newing a NodeCell" }
      
      after(:each) { @result.should have_tag('textarea') }
    end
    
    after(:each) do
      # @fix: Doesn't work via testing for some reason.
      #@result.should include('A test note for &gt;&gt; you.') # make sure HTML escaping is being done
    end
  end
  
  
  describe 'leading to', PileRefNodeCell do
    it_should_behave_like "All NodeCells"
    
    before(:each) do
      mock_node(
        :prop => mock_model(PileRefProp, :ref_pile => mock_model(Pile), :badged? => PileRefProp::badgeable?),
        :children => @mocked_node_children
      )
      @mock_node.prop.ref_pile.should_receive(:name).and_return("A Test Ref'd Pile & Stuff")
      @mock_node.prop.ref_pile.stub(:owner).and_return(mock_model(User))
      @mock_node.prop.ref_pile.should_receive(:root_node).at_least(:once).and_return(mock_model(Node))
      @mock_node.prop.ref_pile.root_node.stub(:children).and_return([])
      @mock_node.prop.stubs(:class => PileRefProp)
    end
    
    describe("show action") { it_should_behave_like "Showing a NodeCell" }
    
    describe "form-based" do
      describe("edit action") { it_should_behave_like "(NYI) Editing a NodeCell" }
      describe("new action") { it_should_behave_like "(NYI) Newing a NodeCell" }
      
      #after(:each) {  @result.should have_tag('input[type=text]') }
    end
    
    after(:each) do
      #@result.should have_tag('section')
      @result.should include("A Test Ref'd Pile &amp; Stuff") # make sure HTML escaping is being done
    end
  end
  
  
  describe 'leading to', PriorityNodeCell do
    it_should_behave_like "All NodeCells"
    
    before(:each) do
      mock_node(
        :prop => mock_model(PriorityProp, :priority => 110000000000, :badged? => PriorityProp::badgeable?),
        :children => @mocked_node_children
      )
      @mock_node.prop.stubs(:class => PriorityProp)
    end
    
    describe("show action") { it_should_behave_like "Showing a NodeCell" }
    
    describe "form-based" do
      describe("edit action") { it_should_behave_like "Editing a NodeCell" }
      describe("new action") { it_should_behave_like "Newing a NodeCell" }
      
      after(:each) { @result.should have_tag('input[type=radio]') }
    end
    
    after(:each) do
      # @fix: Doesn't work via testing for some reason.
      #@result.should include('110000000000')
    end
  end
  
  
  describe 'leading to', TagNodeCell do
    it_should_behave_like "All NodeCells"
    
    before(:each) do
      mock_node(
        :prop => mock_model(TagProp, :tag => 'test-tag', :badged? => TagProp::badgeable?),
        :children => @mocked_node_children
      )
      @mock_node.prop.stubs(:class => TagProp)
    end
    
    describe("show action") { it_should_behave_like "Showing a NodeCell" }
    
    describe "form-based" do
      describe("edit action") { it_should_behave_like "Editing a NodeCell" }
      describe("new action") { it_should_behave_like "Newing a NodeCell" }
      
      after(:each) { @result.should have_tag('input[type=text]') }
    end
    
    after(:each) do
      # @fix: Doesn't work via testing for some reason.
      #@result.should include('test-tag')
    end
  end
  
  
  describe 'leading to', TextNodeCell do
    it_should_behave_like "All NodeCells"
    
    before(:each) do
      mock_node(
        :prop => mock_model(TextProp, :text => 'test text', :badged? => TextProp::badgeable?),
        :children => @mocked_node_children
      )
      @mock_node.prop.stubs(:class => TextProp)
    end
    
    describe("show action") { it_should_behave_like "Showing a NodeCell" }
    
    describe "form-based" do
      describe("edit action") { it_should_behave_like "Editing a NodeCell" }
      describe("new action") { it_should_behave_like "Newing a NodeCell" }
      
      after(:each) { @result.should have_tag('input[type=text]') }
    end
    
    after(:each) do
      # @fix: Doesn't work via testing for some reason.
      #@result.should include('test text')
    end
  end
  
  
  describe 'leading to', TimeNodeCell do
    it_should_behave_like "All NodeCells"
    
    before(:each) do
      @time_now = Time.now
      mock_node(
        :prop => mock_model(TimeProp, :time => @time_now, :badged? => TimeProp::badgeable?),
        :children => @mocked_node_children
      )
      @mock_node.prop.stubs(:class => TimeProp)
    end
    
    describe("show action") { it_should_behave_like "Showing a NodeCell" }
    
    describe "form-based" do
      describe("edit action") { it_should_behave_like "Editing a NodeCell" }
      describe("new action") { it_should_behave_like "Newing a NodeCell" }
      
      after(:each) { @result.should have_tag('input[type=text]') }
    end
    
    after(:each) do
      # @fix: Doesn't work via testing for some reason.
      #@result.should include(@time_now.to_s)
    end
  end
end