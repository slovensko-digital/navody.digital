Rails.application.routes.draw do
  root to: 'static#index'

  get :health, to: 'health#index'
end
