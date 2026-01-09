Rails.application.routes.draw do
  # Mount Lookbook in development for ViewComponent previews
  mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # User settings
  resource :settings, only: [:show, :update]

  # Organization management (admin)
  resource :organization, only: [:show, :update] do
    resources :invitations, only: [:index, :create, :destroy]
  end

  # Public invitation acceptance
  get "invitations/:token/accept", to: "invitations#accept", as: :accept_invitation

  # User search for combobox
  get "users/search", to: "users#search", as: :users_search

  # Tag routes for combobox
  get "tags/search", to: "tags#search", as: :tags_search
  resources :tags, only: [:create, :update, :destroy]

  # Task routes
  resources :tasks do
    member do
      get :kanban
      post :reorder_children
    end
    resources :versions, only: [:index, :show] do
      member do
        post :restore
      end
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root "tasks#index"
end
