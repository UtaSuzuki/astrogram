Rails.application.routes.draw do
  root 'photos#index'
  
  get  'sessions/new'
  get  'pages/help'
  
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get    '/purchase', to: 'photos#purchase'
  
  resources :users
  resources :events
  resources :conditions
  resources :photos
  resources :cards
end
