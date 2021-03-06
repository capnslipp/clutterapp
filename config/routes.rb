ActionController::Routing::Routes.draw do |map|
  
  #map.resources :followships, :only => [:index, :create, :destroy], :member => { :toggle_follow => :post }
  
  map.stylesheets '/stylesheets/all.css', :controller => 'stylesheets', :action => 'all'
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
      piles.resources :nodes, :except => [:index, :show], :member => {
        :reorder => :put,
        :reparent => :put,
        :update_check_prop_checked => :put, # the action that won't die (it just keeps going and going and…)
        :sub_pile => :put
      }
      
      # /:user_id/piles/:pile_id/props/:type
      # /:user_id/piles/:pile_id/props/:type/...
      piles.resources :props, :as => 'props/:type'
      
    end
    
    users.resources :followships, :only => [:create, :destroy], :member => {
      :toggle_follow => :post
    }, :collection => {
      :following => :get,
      :followers => :get
    }
    
  end
  
  # for now, we're just going to give a log-in form
  #map.root :controller => 'front'
  map.root :controller => 'user_sessions',    :action => 'new',     :conditions => {:method => :get}
  
end
