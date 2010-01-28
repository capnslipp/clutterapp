require 'test_helper'


class DatasetsTest < ActiveSupport::TestCase
  dataset :users, :piles, :nodes
  
  
  test "datasets are working" do
    
    assert_proper_user users(:a_user) do
      assert_proper_pile piles(:a_users_default_pile)
      assert_proper_pile piles(:a_pile) do
        assert_proper_node nodes(:a_piles_root_node) do
          assert_proper_node nodes(:a_plain_text_node)
          assert_proper_node nodes(:a_todo_node) do
            assert_proper_node nodes(:a_sub_todo_node) do
              assert_proper_node nodes(:a_sub_sub_todo_node)
            end # a_sub_todo_node
          end # a_todo_node
          assert_proper_node nodes(:a_prioritized_todo_node)
          assert_proper_node nodes(:a_tagged_todo_node)
          assert_proper_node nodes(:a_multitagged_todo_node)
          assert_proper_node nodes(:a_dated_todo_node)
          assert_proper_node nodes(:a_noted_todo_node)
          assert_proper_node nodes(:a_prioritzed_tagged_dated_noted_todo_node)
        end # a_piles_root_node
      end # a_pile
      assert_proper_pile piles(:a_better_pile) do
        assert_proper_node nodes(:a_better_piles_root_node)
      end
    end # a_user
    
    assert_proper_user users(:another_user) do
      assert_proper_pile piles(:another_users_default_pile)
      assert_proper_pile piles(:another_pile) do
        assert_proper_node nodes(:another_piles_root_node)
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
  
  
  def assert_proper_user(user)
    assert user.present?
    
    if block_given?
      @user_scope = user
      yield
      @user_scope = nil
    end
  end
  
  def assert_proper_pile(pile)
    assert pile.present?
    assert_equal pile.owner, current_user_scope
    
    if block_given?
      @pile_scope = pile
      yield
      @pile_scope = nil
    end
  end
  
  def assert_proper_node(node)
    assert node.present?
    assert_equal node.pile, current_pile_scope
    assert_equal node.root, current_pile_scope.root_node
    assert_equal node.parent, current_node_scope if current_node_scope
    
    if block_given?
      @node_scope << node
      yield
      @node_scope.pop
    end
  end
  
end
