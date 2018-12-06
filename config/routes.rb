Rails.application.routes.draw do
  get :health, to: 'health#index'

  namespace :admin do
    root to: redirect('admin/pages')

    resources :pages, except: [:show]
    resources :journeys, except: [:show] do
      resources :steps, except: [:show] do
        resources :tasks, except: [:show]
      end
    end
  end

  root to: 'static#index'

  resource :search, only: [:show]

  resources :journeys, path: 'zivotne-situacie', only: [:show] do
    resources :steps, path: 'krok', only: [:show]
  end

  resources :user_journeys, path: 'moje-zivotne-situacie' do
    post :start, on: :member, path: 'zacat'

    resources :steps, controller: :user_steps, path: 'krok', only: [:show]
    resources :tasks, controller: :user_tasks, path: 'ulohy' do
      member do
        post :complete
        post :undo
      end
    end
  end

  resource :session

  resources :faqs, path: 'casto-kladene-otazky' do
    root to: 'static#show', defaults: { slug: 'contact-info' }
  end

  get '/:id', to: 'static#show', as: :static_page
end
