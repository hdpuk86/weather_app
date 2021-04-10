Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :heat_ratings, only: [:edit, :update]
  resources :forecasts, only: [:new, :create, :index]

  root to: 'forecasts#index'
end
