require 'test_helper'

class DatasetsTest < ActiveSupport::TestCase
  dataset :users, :piles
  
  test "datasets are working" do
    assert users(:a_user).present?
    assert users(:another_user).present?
    
    assert piles(:a_users_default_pile).present?
    assert piles(:a_pile).present?
    assert piles(:a_better_pile).present?
    assert piles(:another_users_default_pile).present?
  end
  
end