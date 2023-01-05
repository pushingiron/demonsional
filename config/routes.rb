Rails.application.routes.draw do

  resources :rates do
    collection do
      get :load_rates
      get :destroy_all
    end
  end

  get 'users/index'
  root to: 'static_pages#index'

  resources :items

  resources :profiles

  resources :contracts do
    collection do
      get :create_base
      get :copy
    end
  end

  resources :references
  resources :locations
  resources :paths

  resources :shipping_orders do
    collection do
      get :post_xml
      get :import_page
      post :import
      get :csv_example
      get :destroy_all
    end
  end

  devise_for :users, controllers: { sessions: 'users/sessions' }
  # match '/users',   to: 'users#index',   via: 'get'
  # resources :users
  resources :paths

  resources :status_messages do
    collection do
      get :import_page
      post :import
    end
  end

  resources :contracts

  resources :enterprises do
    collection do
      get :post_xml
      post :import
      get :import_page
      get :destroy_all
      get :csv_example
    end
  end

  # get 'static_pages/index'
  # get 'static_pages/xml_response'
  #
  resources :static_pages do
    get :index
    get :xml_response
    collection do
      get :code_table_status
      get :mmo_status
      get :so_example
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  get 'demo_this' => 'static_pages#demo_this'
  post 'create_demo' => 'static_pages#create_demo'
end
