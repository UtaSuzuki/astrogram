Rails.application.routes.draw do
  root 'pages#index'
  
  get  'sessions/new'
  get  'pages/help'
  
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
  resources :events
  resources :conditions
  resources :photos
end
