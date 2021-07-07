Rails.application.routes.draw do

  get 'users/index'
  root to: 'static_pages#index'

  resources :items

  resources :references
  resources :locations

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


  resources :enterprises do
    collection do
      get :post_xml
      post :import
      get :import_page
      get :destroy_all
    end
  end

  # get 'static_pages/index'
  # get 'static_pages/xml_response'
  #
  resources :static_pages do
    get :index
    get :xml_response
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  get "demo_this" => "static_pages#demo_this"
  post "create_demo" => "static_pages#create_demo"
end
