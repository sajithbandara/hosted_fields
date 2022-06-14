Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'checkouts#new'
  resources :checkouts, only: [:show, :index, :new, :create]
end
