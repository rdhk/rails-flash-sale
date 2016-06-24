Rails.application.routes.draw do

  namespace :admin do
  get 'users/index'
  end

  namespace :admin do
  get 'users/show'
  end

  namespace :admin do
  get 'users/able'
  end

  namespace :admin do
  get 'users/disable'
  end

  # namespace :admin do
  # get 'orders/index'
  # end

  namespace :api do
    get 'deals/live'
    get 'deals/past'
    get 'myorders', to: 'orders#index'
  end

  namespace :admin do
    resources :deals do
      member do
        get 'unpublish'
        get 'publish'
      end
      collection do
        get 'revenue_report'
        get 'potential'
      end
    end
    resources :orders, only: [:index, :show] do
      member do
        post 'mark_delivered'
        post 'mark_cancelled'
      end
    end
    resources :users, only: [:index, :show] do
      member do
        post 'enable'
        post 'disable'
      end
    end
  end


  get 'deals/past'
  resources :deals, only: [:index, :show] do
    member do
      get 'check_status'
    end
  end
  resources :addresses, only: [:create]
  resources :payment_transactions, only: [:index, :show]
  resources :orders, only: [:index, :show] do
    collection do
      post 'add_item'
      post 'remove_item'
      end
    member do
      get 'checkout'
      post 'charge'
      post 'preview'
    end
  end

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
