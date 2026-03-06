require 'sidekiq/web'
require 'devise'
Rails.application.routes.draw do

  devise_for :users
  mount Sidekiq::Web => '/sidekiq'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  root "home#index"
  get "dashboard", to: "dashboard#index", as: :dashboard
  resources :jobs, only: [:index, :show] do
    resources :job_applications, only: [:create]
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: :dashboard
  end

  namespace :api do
    namespace :v1 do
      post   '/signup', to: 'registrations#create'
      post   '/login',  to: 'sessions#create'
      resources :companies, only: %i[index show create update destroy]
      resources :jobs, only: %i[index show create update destroy]
      resources :job_applications, only: %i[index show create update]
    end
  end
end
