module InvitesHelper
  
  def current_user_invites_remaining
    invites_remaining = current_user.invites_remaining
    
    if invites_remaining.to_f.infinite?
      'unlimited'
    else
      invites_remaining
    end
  end
  
end
