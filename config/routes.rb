ActionController::Routing::Routes.draw do |map|
  
  map.stylesheets '/stylesheets/:id.css', :controller => 'stylesheets', :action => 'show'
  
  map.login   '/in',                      :controller => 'sessions',    :action => 'create'
  map.logout  '/out',                     :controller => 'sessions',    :action => 'destroy'
  map.resource :session, :as => 'sess'
  
  map.users '/reg',                       :controller => 'users',       :action => 'create'
  map.new_user  '/sup',                   :controller => 'users',       :action => 'new'
  map.new_user '/sup/:invite_token',      :controller => 'users',       :action => 'new'
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
    
  end
  
  map.about '/about', :controller => 'front'
  map.root :controller => 'front'
  
end
