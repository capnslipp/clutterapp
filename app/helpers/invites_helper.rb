module InvitesHelper
  
  def current_users_invites_remaining
    unless logged_in?
      nil
    else
      invites_remaining = current_user.invites_remaining
      
      if invites_remaining == INFINITY
        'unlimited'
      else
        invites_remaining
      end
    end
  end
  
end
