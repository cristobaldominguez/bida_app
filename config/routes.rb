Rails.application.routes.draw do
  resources :log_standards
  resources :tasks
  resources :bounds
  resources :standards
  resources :companies do
    resources :plants, only: %i[new create update destroy]
  end
  resources :plants, path_prefix: '/companies/:company_id', except: %i[new create update destroy] do
    resources :sampling_lists
    resources :logbooks
    resources :inspections
    resources :alerts
    resources :supports do
      collection do
        get 'custom'
      end
    end
  end

  resources :work_summaries, only: :destroy

  devise_for :users
  resources :users

  devise_scope :user do
    authenticated :user do
      root 'companies#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
