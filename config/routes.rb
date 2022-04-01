Rails.application.routes.draw do
  devise_for :users
  resources :courses
  resources :users, only: [:index, :edit, :update]
  root 'home#index'
  get 'home/activities'
end
