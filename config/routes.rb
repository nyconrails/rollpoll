Rollpoll::Application.routes.draw do

  resources :topics
  resources :sessions

  resources :questions, except: [:edit, :destroy] do
    resources :answers, only: :show do
      get :vote, on: :member, as: :vote
    end
  end

  resources :users, only: [:new, :index, :create, :show] do
    get :username_check, on: :collection
  end

  match '/login' => "sessions#new", as: :login
  match '/logout' => "sessions#destroy", as: :logout
  match '/registration' => "users#new", as: :registration
  match '/users/username_check/:uname' => 'users#username_check'

  root :to => 'pages#index'

end
