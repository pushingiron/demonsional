Rails.application.routes.draw do
  resources :enterprises
  devise_for :users, controllers: { sessions: 'users/sessions' }
  root to: "homes#index"
  get 'homes/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #

end
