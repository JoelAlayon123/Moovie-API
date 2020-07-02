Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :genres
  resources :users
  
  get '/movies', to: "movies#index"
  get '/movies/:id', to: "movies#show"

  get '/users/:id/lists', to:'lists#index'
  get '/lists/:id', to:'lists#show'
  post '/lists', to:'lists#create'
  put '/lists/:id', to:'lists#update'
  delete '/lists/:id', to:'lists#destroy'
  put '/movies/:movie_id/lists/:list_id', to:'lists#add_movie'
  delete '/movies/:movie_id/lists/:list_id', to:'lists#remove_movie'

  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
