Rails.application.routes.draw do
  require 'sidekiq/web'

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    get 'pages/index'
    get 'pages/no_permission'
    get 'exports/logbook/:id', to: 'exports#logbook', as: 'export_logbook'

    resources :log_standards, :bounds, :standards, :charts, :incident_types
    resources :logs, only: [:update]

    get 'locales/show', to: 'locales#show'
    get 'locales/all', to: 'locales#index'

    resources :tasks do
      collection do
        get 'defaults/:lang', to: 'tasks#defaults'
      end
    end

    resources :companies do
      resources :plants, only: %i[index new create update destroy]
    end
    resources :plants, path_prefix: '/companies/:company_id', except: %i[new create update destroy] do
      resources :sampling_lists do
        collection do
          get 'external'
          get 'internal'
        end
      end
      resources :logbooks, except: %i[new create]
      resources :inspections, :alerts, :flows, :graphs, :graph_standards
      resources :todos do
        member do
          delete 'delete_image/:image_id', to: 'todos#delete_image', as: 'delete_image'
          patch 'completed/:value', to: 'todos#completed', as: 'completed'
        end
      end
      resources :flow_reports do
        collection do
          get 'custom'
        end
      end
      resources :reports do
        collection do
          get 'latest_report'
        end
      end
      resources :supports do
        collection do
          get 'custom'
        end
      end
      resources :imports, only: %i[new create] do
        collection do
          get  'flows'
          post 'flows_create'
          get  'samplings'
          post 'samplings_create'
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
  end
end
