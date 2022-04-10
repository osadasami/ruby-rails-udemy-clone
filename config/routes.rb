Rails.application.routes.draw do
  devise_for :users

  resources :enrollments do
    get :my, on: :collection
  end
  resources :courses do
    get :purchased, on: :collection
    get :pending_review, on: :collection
    get :my, on: :collection
    resources :lessons, only: [:new, :create, :show, :edit, :update, :destroy]
  end
  resources :users, only: [:index, :edit, :update, :show]
  resources :activities, only: [:index]

  root 'home#index'
  get 'activity', to: 'home#activity'
end
