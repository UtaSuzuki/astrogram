Rails.application.routes.draw do
  root 'photos#index'
  
  get  'sessions/new'
  get  'pages/help'
  
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users, only: [:new, :create, :show]
  resources :events
  resources :conditions
  resources :photos do
    resources :orders do
      member do
        get 'new'
        post 'pay'
      end
    end
  end
  resources :cards, only: [:new, :create, :show, :destroy]
  resources :orders, only: [:new, :index] do
    member do
      get 'sales_index'
    end
  end
end
