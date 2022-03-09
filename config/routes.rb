Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "application#index"

  get 'task/list'
  get 'task/list_today'
  post 'task/create'
  delete 'task/delete'

  get 'project/list'
  post 'project/create'

  #match '*path' => redirect('/'), via: :get

end
