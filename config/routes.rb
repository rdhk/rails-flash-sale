Rails.application.routes.draw do

  get 'payment_transactions/show'

  get 'payment_transactions/index'

  namespace :admin do
    resources :deals do
      member do
        get 'unpublish'
        get 'publish'
      end
    end
  end

  get 'deals/past'
  resources :deals, only: [:index, :show]
  resources :addresses, only: [:create]
  resources :payment_transactions, only: [:index, :show]
  #FIXME_AB: we don't need all routes for orders
  resources :orders do
    member do
      get 'checkout'
      post 'charge'
      post 'preview'
    end
  end
  #FIXME_AB: rest
  post 'orders/add_item'
  post 'orders/remove_item'
  # post 'orders/preview'
  get 'activation/:token' => 'users#activate', as: 'activate'
  resources :password_requests, only: [:new, :create]
  resources :password_resets, only: [:new, :create]

  get 'password_resets/new/:token' => 'password_resets#new', as: 'reset_password'

  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users, only: [:new, :create]

  get '/admin' => 'admin/deals#index'
  root 'deals#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
