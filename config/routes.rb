Rails.application.routes.draw do
  # get 'users/show'
  resources :rooms
  delete 'rooms/:id', to: 'rooms#destroy'

  resources :rooms do
    resources :messages
    collection do 
      post :search        # search_rooms_path
    end
  end
    
  get 'rooms/join/:id', to: 'rooms#join', as: 'join_room'       # join_room_path(room_id)   to Rooms controller, join action 
  get 'rooms/leave/:id', to: 'rooms#leave', as: 'leave_room'    # leave_room_path(room_id)  to Rooms controller, leave action

  get 'rooms/index'
  get 'pages/home'
  root 'rooms#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # devise_scope :user do
  #   # Redirests signing out users back to sign-in
  #   get "users", to: "devise/sessions#new"
  # end
  
  get 'users/:id', to: 'users#show', as: 'user' # goes to users controller show method

  # Defines the root path route ("/")
  # root "articles#index"
end