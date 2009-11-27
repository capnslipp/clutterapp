# scoped_block: A crafty little extension to execute blocks with an object's scope.
# by: Slippy Douglas


# Use like this:
# 
#   5.in_scope do
#     puts self.to_f
#   end
# 
# @fix: needs a fall-through to the scope it was called from
class Object
  def in_scope(&block)
    self.instance_eval(&block)
  end
end


# Use like this:
# 
#   [5, 10].each(&with_scope do
#     puts self.to_f
#   end)
# 
# @fix: strange bugs with active_support/option_merger when nested 3 levels deep in routes.rb
# @fix: doesn't play well in ERB files
# @fix: with_scope is already used by Rails
#module Kernel
#  def with_scope(&block)
#    return lambda { |obj|
#      obj.instance_eval(&block)
#    }
#  end
#end
