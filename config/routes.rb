Magazine::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :subscribers, only: [:create] do
    member do
      get :unsubscribe
    end
  end

  resources :messages, except: [:edit, :update] do
    # member do
    #   post :reply
    # end
  end

  get "contact/index"

  devise_for :users, :controllers => { :registrations => 'registrations' } do
    get 'users/sign_out' => 'devise/sessions#destroy'
  end

  #root :to => "upload_images#index" #Version 1
  root :to => "articles#index"

  get "admin/login"

  get "admin/logout"

  post "admin/check"

  # get "info/term"

  get "info/privacy"

  # get "info/dmca"

  get "info/contact"

  get "filter/brokenscanner"

  get "filter/broken"

  get "filter/all"

  #match 'random' => 'upload_images#random'
  match '/s/:id' => "shortener/shortened_urls#show"
  match 'random' => 'articles#random'
  match 'search' => 'search#index'
  match 'filter' => 'filter#index'

  #resource :trackings do
  #  collection do
  #    post 'update_threshold'
  #  end
  #end

  #get 'trackings/show/:id', to: 'trackings#show', constraints: {id: /\d+/}, as: 'trackings_publisher'

  #post "urls/create"
  #delete "urls/destroy/:id", to: 'urls#destroy'

  resources :urls

  resources :pages

  resources :articles, except: [:update]
  resources :articles, only: [:update], defaults: { format: :json }


  #resources :upload_images do
  #  collection do
  #    post 'like_this'
  #  end
  #end

  resources :comments do
    collection do
      post 'view_all'
    end
  end

  resources :users do
    collection do
      post 'click_ad'
    end
  end

  resources :publishers do
    collection do
      post 'update_threshold'
      get 'generate_publisher_sheet'
    end
  end

  get "article/index"

  get "popular/index"

  get "popular/article_index"

  get "articles/clearcache"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
