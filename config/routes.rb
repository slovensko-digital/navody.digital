Rails.application.routes.draw do
  get :health, to: 'health#index'

  namespace :admin do
    root to: 'dashboard#show'

    resources :journeys do
      resources :steps
    end
    resources :tasks
  end

  get '/static/:slug', to: 'static#show', as: 'static_page', defaults: {is_faq: false}
  get '/faq/:slug', to: 'static#show', as: 'faq_page', defaults: {is_faq: true}

  root to: 'static#index'

  resources :journeys, path: 'zivotne-situacie'
  get '/zivotne-situacie/:id/:step_slug', to: 'journeys#show', as: 'journey_step' # TODO

  resources :faqs, path: 'casto-kladene-otazky'
  get '/:slug', to: 'static#show', as: :static_page
end
