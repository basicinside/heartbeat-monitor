HeartbeatMonitor::Application.routes.draw do
  resources :traffic_bytes
  resources :traffic_packets

  resources :authentications
  match '/auth/:provider/callback' => 'authentications#create'
  devise_for :users, :controllers => {:registrations => 'registrations'}
  devise_for :users

  resources :locations
  match 'nodes/register/:id' => 'nodes#register', :as => :register_node
  match 'nodes/register/' => 'nodes#register', :as => :register_node
  match 'nodes/traffic_bytes' => 'nodes#traffic_bytes', :as => :traffic_bytes
  match 'nodes/traffic_packets' => 'nodes#traffic_packets', :as => :traffic_packets
  resources :groups
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  resources :user_sessions
  resources :users
  resources :devices
  #match 'fehlerberichte/new' => 'bugreports#new', :via => post
  resources :bugreports
  resources :lands
  resources :landesverbands
  match 'highscores/:action' => 'highscores#index', :as => :highscores
  resources :parties
  resources :highscores
  match 'api/node/:hostname/:ip' => 'api#node', :as => :api_node
  match 'api/node/:hostname/:ip/:lat/:lon' => 'api#node', :as => :api_node
  match 'api/link/:from_ip/:to_ip/:quality' => 'apis#link', :as => :api_node
  resources :crews
  match 'nodes/georss' => 'nodes#georss', :as => :nodes_georss
  match 'nodes/feed' => 'nodes#feed', :as => :nodes_feed
  match 'links/feed' => 'links#feed', :as => :links_feed
  resources :nodes
  match 'karte' => 'maps#map', :as => :karte
  match 'karte2' => 'maps#map', :as => :karte2
  resources :maps
  match '/faq/' => 'faqs#index'
  match '/' => 'highscores#index'
  match '/:controller(/:action(/:id))'
  root :to => "highscores#index"
end
# The priority is based upon order of creation:
# first created -> highest priority.

# Sample of regular route:
#   match 'products/:id' => 'catalog#view'
# Keep in mind you can assign values other than :controller and :action

# Sample of named route:
#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
# This route can be invoked with purchase_url(:id => product.id)

# Sample resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Sample resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Sample resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Sample resource route with more complex sub-resources
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', :on => :collection
#     end
#   end

# Sample resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

# You can have the  of your site routed with "roo"
# just remember to delete public/index.html.
# root :to => "welcome#index"

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id(.:format)))'
