Rails.application.routes.draw do

  resources :items

  resources :references
  resources :locations

  resources :shipping_orders do
    collection do
      get :post_xml
      get :import_page
      post :import
      get :csv_example
    end
  end

  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :enterprises do
    collection do
      get :post_xml
    end
  end

  root to: 'static_pages#index'
  # get 'static_pages/index'
  # get 'static_pages/xml_response'
  #
  resources :static_pages do
    get :index
    get :xml_response
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #

end
