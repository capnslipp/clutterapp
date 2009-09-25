ActionController::Routing::Routes.draw do |map|
# friendly user URLs
  
  map.login   '/sin',               :controller => 'sessions',  :action => 'create'
  map.logout  '/sout',              :controller => 'sessions',  :action => 'destroy'
  map.resource :session, :as => 'sess'
  
  map.users '/reg',              :controller => 'users',     :action => 'create'
  #map.signup  '/sup',               :controller => 'users',     :action => 'new'
  # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
  map.new_user '/sup/:invite_token',  :controller => 'users',     :action => 'new'
  map.resources :invites, :as => 'inv'
  
  #map.users :users, :only => [:create]
  
  map.resources :users, :default => true, :except => [:index, :create, :new], :requirements => { :id => /[^\/]{6,}/ } do |users|
    users.resources :piles
  end
  
  map.root :controller => 'home'
  
  
# back-end XHR URLs
  
  map.resources :piles do |piles|
    piles.resources :nodes, :member => {
      :move_up => :put,
      :move_down => :put,
      :move_in => :put,
      :move_out => :put,
      :update_check_prop_checked => :put,
      :set_note_prop_note => :put,
      :set_priority_prop_priority => :put,
      :set_tag_prop_tag => :put,
      :set_text_prop_text => :put,
      :set_time_prop_time => :put
    }
    
    piles.resources :props, :as => 'props/:type'
  end
  
end
