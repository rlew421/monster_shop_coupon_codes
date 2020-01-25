Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  resources :merchants
  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"

  resources :items, only: [:index, :show, :edit, :update, :destroy]
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"

  resources :merchants do
    resources :items, only: [:index, :new, :create, :edit]
  end

  resources :merchants do
    resources :items, only: [:update], to: "merchant/items#update"
    resources :items, only: [:destroy], to: "merchant/items#destroy"
  end
  # get "/merchants/:merchant_id/items", to: "items#index"
  # get "/merchants/:merchant_id/items/new", to: "items#new"
  # post "/merchants/:merchant_id/items", to: "items#create"
  # get 'merchants/:merchant_id/items/:items_id/edit', to: "items#edit"
  # patch 'merchants/:merchant_id/items/:item_id', to: "merchant/items#update"
  # delete 'merchants/:merchant_id/items/:item_id', to: "merchant/items#destroy"
  # delete "/items/:id", to: "items#destroy"

  resources :items do
    resources :reviews, only: [:new, :create]
  end
  # get "/items/:item_id/reviews/new", to: "reviews#new"
  # post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy]
  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  delete "/cart/:item_id/quantity", to: "cart#remove_item_quantity"
  patch '/cart', to: "cart#apply_coupon"

  resources :orders, only: [:new, :create, :show]
  # get "/orders/new", to: "orders#new"
  # post "/orders", to: "orders#create"
  # get "/orders/:id", to: "orders#show"
  patch "/orders/:id", to: "orders#cancel"

  get "/register", to: "users#new"
  resources :users, only: [:create]
  # post "/users", to: "users#create"
  get "/users", to: "sessions#show"
  get "/profile", to: "users#show"
  get "/profile/orders", to: "orders#index"
  get "/profile/orders/:id", to: "orders#show"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/password/edit", to: "users#edit"
  patch "/profile/password", to: "users#update"

  namespace :merchant do
    get '/', to: "merchant#show"
    get '/:merchant_id/items', to: "items#index"
    resources :orders, only: [:show]
    # get '/orders/:id', to: 'orders#show'
    get '/:merchant_id/items/new', to: "items#new"
    post '/:merchant_id/items', to: "items#create"
    # get '/:merchant_id/:items_id/edit', to: "items#edit"
    # patch '/:merchant_id/:items_id', to: "items#update"
    get '/orders/:order_id/item_orders/:item_order_id/fulfill', to: 'item_orders#fulfill'
    # get '/coupons', to: 'coupons#index'
    # get '/coupons/new', to: 'coupons#new'
    # get 'coupons/:coupon_id', to: 'coupons#show'
    # post '/coupons', to: 'coupons#create'
    # get '/coupons/:coupon_id/edit', to: 'coupons#edit'
    # patch '/coupons', to: 'coupons#update'
    # delete '/coupons/:coupon_id', to: 'coupons#destroy'
  end

  namespace :merchant do
    resources :coupons
  end

  namespace :admin do
    get '/', to: "admins#show"
    resources :orders, only: [:update]
    resources :merchants, only: [:index, :update, :show]
    resources :users, only: [:index, :show]
    patch '/users/:user_id/profile', to: "users#update"
    get '/users/:user_id/password/edit', to: "users#edit"
    get '/users/:user_id/profile/edit', to: "users#edit"
    patch 'users/:user_id/password', to: "users#update"
    get '/users/:user_id/upgrade_to_merchant_employee', to: "users#change_role"
    get '/users/:user_id/upgrade_to_merchant_admin', to: "users#change_role"
  end

  # namespace :admin do
    # get '/', to: "admins#show"
    # get '/merchants/', to: "merchants#index"
    # patch '/merchants/:merchant_id', to: 'merchants#update'
    # get '/merchants/:merchant_id', to: "merchants#show"
    # get '/users', to: "users#index"
    # get '/users/:user_id/', to: "users#show"
    # get '/users/:user_id/profile/edit', to: "users#edit"
    # patch '/orders/:id', to: "orders#update"
  # end

  scope :admin do
    get '/merchants/:merchant_id/items', to: "merchant/items#index"
  end
end
