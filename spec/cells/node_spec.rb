require 'spec_helper'

describe NodeCell do
  
  def mock_node(stubs={})
    @node ||= mock_model(Node, stubs)
  end
  
end
