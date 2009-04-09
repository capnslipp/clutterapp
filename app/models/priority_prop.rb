class PriorityProp < ActiveRecord::Base
  has_one :node, :as => :prop
end
