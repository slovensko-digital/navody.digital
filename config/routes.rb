Rails.application.routes.draw do
  get :health, to: 'health#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  namespace :admin do
    root to: redirect('admin/pages')

    resources :pages, except: [:show]
    resources :journeys, except: [:show] do
      resources :steps, except: [:show] do
        resources :tasks, except: [:show]
      end
    end
    resources :user_journeys
  end

  root to: 'static#index'

  resource :search, only: [:show]

  resources :journeys, path: 'zivotne-situacie', only: [:show] do
    resources :steps, path: 'krok', only: [:show]
  end

  resources :user_journeys, path: 'moje-zivotne-situacie' do
    post :start, on: :member, path: 'zacat'

    resources :steps, controller: :user_steps, path: 'krok' do
      member do
        post :complete
        post :submit
        get :submit_confirmation
      end
    end
    resources :tasks, controller: :user_tasks, path: 'ulohy' do
      member do
        post :complete
        post :undo
      end
    end
  end

  resource :session, only: [:new, :create, :destroy]
  get '/auth/magiclink/info', to: 'sessions#magic_link_info'
  get '/auth/failure', to: 'sessions#failure'
  get '/auth/:provider/callback', to: 'sessions#create', as: :auth_callback
  get '/auth/:provider', to: lambda{ |_| [404, {}, ["Not Found"]] }, as: :auth

  resources :faqs, path: 'casto-kladene-otazky'
  resources :pages, path: '', only: 'show'
end
