Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  devise_for :users
  resources :books
  root to: 'books#index'
end
