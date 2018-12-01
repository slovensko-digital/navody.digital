Rails.application.routes.draw do
  root to: 'static#index'

  get :health, to: 'health#index'

  get '/static/:slug', to: 'static#show', as: 'static_page'

  namespace :admin do
    root to: 'dashboard#show'

    resources :journeys
  end
end
