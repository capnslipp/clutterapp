require 'spec_helper'

describe PileRefNodeCell do
  
  def mock_node(stubs={})
    @node ||= mock_model(Node, stubs)
  end
  
end
