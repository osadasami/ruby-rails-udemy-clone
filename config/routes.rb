# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :enrollments
  resources :courses do
    get :purchased, on: :collection
    get :pending_review, on: :collection
    get :my, on: :collection
    resources :lessons, only: %i[new create show edit update destroy]
  end
  resources :users, only: %i[index edit update show]
  resources :activities, only: [:index]

  root 'home#index'
  get 'activity', to: 'home#activity'
end
