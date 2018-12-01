Rails.application.routes.draw do
  root to: 'static#index'

  get :health, to: 'health#index'

  get '/static/:slug', to: 'static#show', as: 'static_page', defaults: {is_faq: false}
  get '/faq/:slug', to: 'static#show', as: 'faq_page', defaults: {is_faq: true}

  get '/zivotne-situacie', to: redirect('/')
  get '/zivotne-situacie/:slug', to: 'journeys#show', as: 'journey'
  get '/zivotne-situacie/:slug/:step_slug', to: 'journeys#show', as: 'journey_step'

  post '/user_journeys', to: 'user_journeys#create', as: 'create_user_journey'
  get '/user_journeys/:id', to: 'user_journeys#show', as: 'user_journey'

  get '/log_in', to: 'sessions#new', as: 'log_in'
  post '/log_in', to: 'sessions#create', as: 'log_me_in'
  delete '/log_out', to: 'sessions#destroy', as: 'log_out'
end
