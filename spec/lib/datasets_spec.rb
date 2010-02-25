require 'spec_helper'

describe "datasets" do
  dataset :users, :piles, :nodes
  
  
  it "should have a tree structure matching the constructed users, piles, and nodes" do
    
    proper! users(:slippy_douglas) do
      
      proper! piles(:slippys) do
        proper! piles(:slippys).root_node do
          proper! nodes(:a_plain_text_node)
          proper! nodes(:plans_sub_pile_ref_node)
          proper! nodes(:resposiblities_sub_pile_ref_node)
          proper! nodes(:a_todo_node) do
            proper! nodes(:a_sub_todo_node) do
              proper! nodes(:a_sub_sub_todo_node)
            end # a_sub_todo_node
            proper! nodes(:a_sibling_sub_todo_node)
            proper! nodes(:another_sibling_sub_todo_node)
          end # a_todo_node
          proper! nodes(:a_prioritized_todo_node)
          proper! nodes(:a_tagged_todo_node)
          proper! nodes(:a_multitagged_todo_node)
          proper! nodes(:a_dated_todo_node)
          proper! nodes(:a_noted_todo_node)
          proper! nodes(:a_prioritzed_tagged_dated_noted_todo_node)
        end # slippyss_root_node
      end # slippys
      
      proper! piles(:plans_to_rule_the_world) do
        proper! piles(:plans_to_rule_the_world).root_node do
          proper! nodes(:plans_to_rule_the_world_desc_node)
          proper! nodes(:step_1_sub_pile_ref_node)
        end
      end # plans_to_rule_the_world
      
      proper! piles(:step_1_the_girl) do
        proper! piles(:step_1_the_girl).root_node do
          proper! nodes(:step_1_the_girl_desc_node)
        end
      end # step_1_the_girl
      
      proper! piles(:every_day_responsibilities) do
        proper! piles(:every_day_responsibilities).root_node do
          proper! nodes(:every_day_responsibilities_one)
        end
      end # every_day_responsibilities
      
    end # slippy_douglas
    
    
    proper! users(:josh_vera) do
      proper! piles(:joshs) do
        proper! piles(:joshs).root_node
      end # joshs
    end # josh_vera
    
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
