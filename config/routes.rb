Rails.application.routes.draw do
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  devise_for :users
  resources :books
  resources :users, only: [:index, :show]
  root to: 'books#index'
end
