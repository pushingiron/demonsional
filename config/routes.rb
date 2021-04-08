Rails.application.routes.draw do

  resources :locations
  resources :shipping_orders
  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :enterprises do
    collection do
      get :post_xml
    end
  end

  root to: "static_pages#index"
  get 'static_pages/index'
  get 'static_pages/xml_response'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #

end
