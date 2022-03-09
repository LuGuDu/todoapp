Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "application#index"

  get 'task/list'
  post 'task/create'
  delete 'task/delete'
  
  post 'project/create'

  match '*path' => redirect('/'), via: :get

end
