Rails.application.routes.draw do

  get 'flash/show'

  resources :books do
    resources :evidence, only: [ :create, :new, :destroy ]
    resources :photos, only: [ :update, :index, :show ] do
      patch 'restore_queue', on: :collection
    end
    resources :title_pages, only: [ :create, :destroy ]
  end

  resources :title_pages, only: :show

  resources :evidence, only: [ :show, :update, :edit, :index ]

  resources :names do
    get :autocomplete_name, on: :collection
  end

  namespace :flickr do
    resources :evidence, only: [ :show, :update, :destroy ] do
      post :create, on: :member
      get :status, on: :member
    end

    resources :title_pages, only: [ :show, :update, :destroy ] do
      post :create, on: :member
      get :status, on: :member
    end

    resources :books, only: [ :show, :update, :destroy ] do
      post :create, on: :member
      get :status, on: :member
    end
  end

  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  resources :user, :controller => "user"

  get 'welcome/index'

  root to: 'books#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  post 'books/:id/add_title_page/:photo_id' => 'books#add_title_page', as: :add_title_page, defaults: { format: :html }

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
