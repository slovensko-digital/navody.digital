Rails.application.routes.draw do
  get :health, to: 'health#index'

  namespace :admin do
    root to: redirect('admin/journeys#index')

    resources :journeys do
      resources :steps do
        resources :tasks
      end
    end
  end

  root to: 'static#index'

  get :search, to: 'search#show'

  get '/zivotne-situacie', to: redirect('/')
  get '/zivotne-situacie/:slug', to: 'journeys#show', as: 'journey'
  get '/zivotne-situacie/:slug/:step_slug', to: 'journeys#show', as: 'journey_step'

  post '/user_journeys', to: 'user_journeys#create', as: 'create_user_journey'
  get '/user_journeys/:id', to: 'user_journeys#show', as: 'user_journey'

  get '/log_in', to: 'sessions#new', as: 'log_in'
  post '/log_in', to: 'sessions#create', as: 'log_me_in'
  delete '/log_out', to: 'sessions#destroy', as: 'log_out'

  resources :faqs, path: 'casto-kladene-otazky'
  get '/:slug', to: 'static#show', as: :static_page

  post '/user_task/mark_as_complete', to: 'user_tasks#mark_as_complete', as: 'mark_user_task_as_complete'
  post '/user_task/mark_as_incomplete', to: 'user_tasks#mark_as_incomplete', as: 'mark_user_task_as_incomplete'

end
