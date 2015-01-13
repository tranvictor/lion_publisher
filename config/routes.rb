Magazine::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

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

  root :to => "articles#index"

  get "admin/login"

  get "admin/logout"

  post "admin/check"

  get "info/privacy"
  get "info/contact"

  get "filter/brokenscanner"
  get "filter/broken"
  get "filter/all"

  get '/s/:id', to: "shortener/shortened_urls#show"
  get 'random', to: 'articles#random'
  get 'search', to: 'search#index'
  get 'filter', to: 'filter#index'

  resources :urls

  resources :pages

  resources :articles, except: [:update]
  resources :articles, only: [:update], defaults: { format: :json }

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
end
