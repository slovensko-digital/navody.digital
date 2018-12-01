Rails.application.routes.draw do
  get :health, to: 'health#index'

  root to: 'static#index'

  get :search, to: 'search#show'

  resources :journeys, path: 'zivotne-situacie'
  get '/zivotne-situacie/:id/:step_slug', to: 'journeys#show', as: 'journey_step' # TODO

  resources :faqs, path: 'casto-kladene-otazky' do
    root to: 'static#show', defaults: { slug: 'contact-info' }
  end

  get '/:slug', to: 'static#show', as: :static_page
end
