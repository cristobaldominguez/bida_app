Rails.application.routes.draw do
  resources :companies do
    resources :plants, only: [:new, :create, :destroy]
  end
  resources :plants, path_prefix: '/companies/:company_id', except: [:new, :create, :destroy] do
    resources :alerts, only: [:new, :create, :update, :destroy]
  end
  resources :alerts, path_prefix: '/plants/:plant_id', except: [:new, :create, :update, :destroy]

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
