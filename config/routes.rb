ActionController::Routing::Routes.draw do |map|
  
  #map.resources :followships, :only => [:index, :create, :destroy], :member => { :toggle_follow => :post }
  
  map.stylesheets '/stylesheets/:id.css', :controller => 'stylesheets', :action => 'show'
  
  map.login '/in',                        :controller => 'user_sessions',    :action => 'new',     :conditions => {:method => :get}
  map.connect '/in',                      :controller => 'user_sessions',    :action => 'create',  :conditions => {:method => :post}
  map.logout  '/out',                     :controller => 'user_sessions',    :action => 'destroy', :conditions => {:method => :delete}
  map.resource :user_session, :as => 'sess'
  
  map.users '/reg',                       :controller => 'users',       :action => 'create',  :conditions => {:method => :post}
  map.new_user '/sup',                    :controller => 'users',       :action => 'new',     :conditions => {:method => :get}
  
  map.resources :invites, :as => 'inv'
  
  map.home '/home', :controller => 'home'
  
  # /:user_id
  # /:user_id/...
  map.resources :users, :default => true, :except => [:index, :create, :new], :requirements => { :id => /[^\/]{6,}/ } do |users|
    # /:user_id/piles
    # /:user_id/piles/...
    users.resources :piles do |piles|
      # /:user_id/piles/:pile_id/nodes
      # /:user_id/piles/:pile_id/nodes/...
      piles.resources :nodes, :member => {
        :move => :put,
        :update_check_prop_checked => :put,
        :set_note_prop_note => :put,
        :set_priority_prop_priority => :put,
        :set_tag_prop_tag => :put,
        :set_text_prop_text => :put,
        :set_time_prop_time => :put
      }
      
      # /:user_id/piles/:pile_id/props/:type
      # /:user_id/piles/:pile_id/props/:type/...
      piles.resources :props, :as => 'props/:type'
      
    end
    
    users.resources :followships do |followships|
     followships.resources :only => [:create, :destroy], :member => {:toggle_follow => :post}
    end
    #/:user_id/followin
    users.following '/following', :controller => 'followships', :action => 'following', :conditions => {:method => :get}
    users.followers '/followers', :controller => 'followships', :action => 'followers', :conditions => {:method => :get}
  end
  
  map.about '/about', :controller => 'front'
  
  #map.root :controller => 'front' # for now, we're just going to give a log-in form
  map.root :controller => 'user_sessions',    :action => 'new',     :conditions => {:method => :get}
  
end
