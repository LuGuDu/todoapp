Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'task/list'
  post 'task/create'
  delete 'task/delete'
  
  post 'project/create'

end
