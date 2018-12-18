Rails.application.routes.draw do
  resources :bounds
  resources :standards
  resources :companies do
    resources :plants, only: %i[new create update destroy]
  end
  resources :plants, path_prefix: '/companies/:company_id', except: %i[new create update destroy] do
    resources :alerts, only: %i[new create update destroy]
    resources :supports, only: %i[new create update destroy]
  end
  resources :alerts, path_prefix: '/plants/:plant_id', except: %i[new create update destroy]
  resources :supports, path_prefix: '/plants/:plant_id', except: %i[new create update destroy]

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
