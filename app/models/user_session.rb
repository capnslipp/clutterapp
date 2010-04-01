class UserSession < Authlogic::Session::Base
  
  def dont_remember_me
    return !remember_me
  end
  
  def dont_remember_me=(dont_remember_me_val)
    remember_me = !dont_remember_me_val
  end
end