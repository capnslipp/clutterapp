# scoped_block: A crafty little extension to execute blocks with an object's scope.
# by: Slippy Douglas


# Use like this:
# 
#   5.scoped do
#     puts self.to_f
#   end
# 
class Object
  def scoped(&block)
    self.instance_eval(&block)
  end
end


# Use like this:
# 
#   [5, 10].each(&with_scoped do
#     puts self.to_f
#   end)
# 
module Kernel
  def with_scoped(&block)
    return lambda { |obj|
      obj.instance_eval(&block)
    }
  end
end
