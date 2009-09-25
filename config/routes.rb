ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'
  
  
  map.login   '/sin',               :controller => 'sessions',  :action => 'create'
  map.logout  '/sout',              :controller => 'sessions',  :action => 'destroy'
  map.register '/reg',              :controller => 'users',     :action => 'create'
  #map.signup  '/sup',            :controller => 'users',     :action => 'new'
  # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
  map.signup '/sup/:invite_token',  :controller => 'users',     :action => 'new'
  
  
  map.resources :invites, :as => 'inv'
  
  map.resource :session
  
  #map.user '/:id',                :controller => 'users',    :action => 'show',      :has_many => :nodes
  map.resources :users do |user|
    user.resources :nodes, :member => {
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
  end
  
end
