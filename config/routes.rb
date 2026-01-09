Rails.application.routes.draw do
  devise_for :users

  # User search for combobox
  get "users/search", to: "users#search", as: :users_search

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
