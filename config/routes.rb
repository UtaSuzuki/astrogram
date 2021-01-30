Rails.application.routes.draw do
  root 'photos#index'
  
  get  'sessions/new'
  get  'pages/help'
  
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get    'participants/index'
  post   '/participants', to: 'participants#create'
  delete '/participants', to: 'participants#destroy'
  
  get    'favorites/index'
  post   '/favorites', to: 'favorites#create'
  delete '/favorites', to: 'favorites#destroy'
  
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :events do
    member do
      get 'user_index'
    end
  end
  resources :conditions, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  resources :photos do
    resources :orders do
      member do
        get 'new'
        post 'pay'
      end
    end
    member do
      get 'user_index'
    end
  end
  resources :cards, only: [:new, :create, :show, :destroy]
  resources :orders, only: [:new, :index] do
    member do
      get 'sales_index'
    end
  end
end
