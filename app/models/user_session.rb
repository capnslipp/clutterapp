class UserSession < Authlogic::Session::Base
  
  def dont_remember_me
    return !remember_me
  end
end