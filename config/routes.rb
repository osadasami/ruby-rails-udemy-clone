Rails.application.routes.draw do
  devise_for :users
  resources :courses do
    resources :lessons, only: [:new, :create, :show, :edit, :update, :destroy]
  end
  resources :users, only: [:index, :edit, :update, :show]
  root 'home#index'
  get 'home/activities'
end
