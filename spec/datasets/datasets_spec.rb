require 'spec_helper'

describe "datasets" do
  dataset :users, :piles, :nodes
  
  
  it "should be working" do
    
    proper! users(:a_user) do
      proper! piles(:a_users_default_pile)
      proper! piles(:a_pile) do
        proper! nodes(:a_piles_root_node) do
          proper! nodes(:a_plain_text_node)
          proper! nodes(:a_todo_node) do
            proper! nodes(:a_sub_todo_node) do
              proper! nodes(:a_sub_sub_todo_node)
            end # a_sub_todo_node
          end # a_todo_node
          proper! nodes(:a_prioritized_todo_node)
          proper! nodes(:a_tagged_todo_node)
          proper! nodes(:a_multitagged_todo_node)
          proper! nodes(:a_dated_todo_node)
          proper! nodes(:a_noted_todo_node)
          proper! nodes(:a_prioritzed_tagged_dated_noted_todo_node)
        end # a_piles_root_node
      end # a_pile
      proper! piles(:a_better_pile) do
        proper! nodes(:a_better_piles_root_node)
      end
    end # a_user
    
    proper! users(:another_user) do
      proper! piles(:another_users_default_pile)
      proper! piles(:another_pile) do
        proper! nodes(:another_piles_root_node)
      end # another_pile
    end # another_user
    
  end
  
  
  protected
  
  def current_user_scope
    @user_scope
  end
  
  def current_pile_scope
    @pile_scope
  end
  
  def current_node_scope
    @node_scope ||= []
    @node_scope.last
  end
  
  
  def proper!(instance, &block)
    if instance.instance_of? User
      block_given? ? proper_user!(instance, &block) : proper_user!(instance)
    elsif instance.instance_of? Pile
      block_given? ? proper_pile!(instance, &block) : proper_pile!(instance)
    elsif (instance.instance_of? Node) || (instance.instance_of? BaseNode)
      block_given? ? proper_node!(instance, &block) : proper_node!(instance)
    else
      raise "Undefined instance class “#{instance.class.name}”"
    end
  end
  
  
  def proper_user!(user)
    user.should be_present
    
    if block_given?
      @user_scope = user
      yield
      @user_scope = nil
    end
  end
  
  def proper_pile!(pile)
    pile.should be_present
    pile.owner.should == current_user_scope
    
    if block_given?
      @pile_scope = pile
      yield
      @pile_scope = nil
    end
  end
  
  def proper_node!(node)
    node.should be_present
    node.pile.should == current_pile_scope
    node.root.should == current_pile_scope.root_node
    node.parent.should == current_node_scope if current_node_scope
    
    if block_given?
      @node_scope << node
      yield
      @node_scope.pop
    end
  end
  
end
