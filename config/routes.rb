
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'pages#index'

  get 'about' => 'pages#about'
  get 'simulation' => 'simulation#simulate'
  get 'download' => 'simulation#export'
end
