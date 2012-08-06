Rollpoll::Application.routes.draw do

  resources :topics
  resources :votes
  resources :answers
  resources :questions
  resources :users, only: [:new, :index, :create, :show] do
    get :username_check, on: :collection
  end
  resources :sessions

  match '/login' => "sessions#new", as: :login
  match '/logout' => "sessions#destroy", as: :logout
  match '/registration' => "users#new", as: :registration
  match '/users/username_check/:uname' => 'users#username_check'

  root :to => 'pages#index'

end
