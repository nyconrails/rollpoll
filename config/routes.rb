Rollpoll::Application.routes.draw do

  resources :topics
  resources :votes
  resources :answers
  resources :questions
  resources :users
  resources :sessions

  match '/login' => "sessions#new", as: :login
  match '/logout' => "sessions#destroy", as: :logout

  root :to => 'pages#index'

end
