Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "application#index"

  get 'task/list'
  get 'task/list_today'
  post 'task/create'
  delete 'task/delete'

  get 'project', to: "project#list"
  get 'project/create', to: "project#create_form"
  post 'project/create'
  delete 'project/delete/:id', to: "project#delete"
  get 'project/update/:id', to: "project#update_form"
  post 'project/update', to: "project#update" #CHANGE TO PATCH ON FUTURE


  #match '*path' => redirect('/'), via: :get

end
