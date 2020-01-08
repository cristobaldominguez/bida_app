Rails.application.routes.draw do
  require 'sidekiq/web'

  get 'pages/index'
  get 'pages/no_permission'

  resources :log_standards
  resources :tasks
  resources :bounds
  resources :standards
  resources :charts
  # resources :plants, only: %i[index]
  resources :companies do
    resources :plants, only: %i[index new create update destroy]
  end
  resources :plants, path_prefix: '/companies/:company_id', except: %i[new create update destroy] do
    resources :sampling_lists do
      collection do
        get 'lab'
        get 'internal'
      end
    end
    resources :logbooks
    resources :inspections
    resources :alerts
    resources :flows
    resources :flow_reports do
      collection do
        get 'custom'
      end
    end
    resources :graphs
    resources :reports
    resources :graph_standards
    resources :supports do
      collection do
        get 'custom'
      end
    end
    resources :imports, only: %i[new create] do
      collection do
        get  'flows'
        post 'flows_create'
      end
    end
    member do
      post 'highseason'
      get 'logbook'
    end
  end

  resources :work_summaries, only: :destroy

  devise_for :users, controllers: { confirmations: 'confirmations' }, skip: :registrations
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  resources :users do
    collection do
      post 'uicolor'
    end
  end

  devise_scope :user do
    authenticated :user do
      root 'pages#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
