require 'sidekiq/web'
require 'devise'
Rails.application.routes.draw do

  devise_for :users
  mount Sidekiq::Web => '/sidekiq'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  root "home#index"
  get "dashboard", to: "dashboard#index", as: :dashboard

  namespace :api do
    namespace :v1 do
      post   '/signup', to: 'registrations#create'
      post   '/login',  to: 'sessions#create'
      resources :companies, only: %i[index show create update destroy]
      resources :jobs, only: %i[index show create update destroy]
    end
  end
end
