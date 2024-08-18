Rails.application.routes.draw do
 extend CustomRoutes
          # NOTE: Uncomment this if mvi deployment is used
          # if Rails.env.production?
          #   mount MviDeployment::Engine => '/deployment'
          # end
get :status, to: 'public#status'

 get 'users_dashboard/index'
          # Route for checking application status
 get :status, to: 'public#status'
 root 'public#index'
 get 'about', to: 'public#about'
 get 'dashboard', to: 'users_dashboard#index', as: 'user_dashboard'
 get 'video_list', to: 'users_dashboard#video_list', as: 'video_list'
 resources :movie_notifications

 
 namespace :users_dashboard do
   resources :movie_notifications
   resources :waitlists, only: [:index, :destroy], controller: 'movie_notifications'
   resources :movies, only: %i[index show]
   resources :orders, only: %i[show create update destroy] do
     collection do
       get :previous_orders
       get 'cart'
       post 'add_to_cart'
       delete 'remove_from_cart'
       patch 'checkout'
     end
     member do
       patch :checkout
     end
   end
 end

 resources :users_dashboard, only: [:index] do
   collection do
     get :video_list
   end
 end


 resources :movies

 devise_for :users, controllers: { sessions: 'sessions' }
 namespace :admin do
root to: 'dashboard#index'

           get '/cleanup_dropzone_upload', to: 'admin#cleanup_dropzone_upload', as: :cleanup_dropzone_upload

           get '/action_modal', to: 'application#action_modal', as: :action_modal

           patch '/destroy_uploads', to: 'admin#destroy_uploads', as: :destroy_uploads

           get 'dashboard/index'
  resources :covers, only: :show
resources :movie_actors, shallow: true  do
 collection do 
 get :actor_movies
 end


end

resources :actors, shallow: true  do


resources :movie_actors, shallow: true do 
 collection do 
 get :actor_movies 
 end
 end 


end

resources :communication_records, shallow: true 
resources :genres, shallow: true 
resources :movie_copies, shallow: true 
resources :movies, shallow: true  do

 member do 
 get :private_cover
 
 end


resources :movie_actors, shallow: true
resources :movie_copies, shallow: true

end

resources :movie_genres, shallow: true 
resources :movie_notifications, shallow: true 
resources :orders, shallow: true  do

 member do 
 get :returned
 
 end


 collection do 
 get :outstanding_orders
 
  
 end


end

resources :order_movie_copies, shallow: true 
resources :users, shallow: true  do

 member do 
 get :reset_password
 
 end


resources :movie_notifications, shallow: true
resources :orders, shallow: true

end

resources :user_ratings, shallow: true 
end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
