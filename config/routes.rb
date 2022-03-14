Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "task#list"

  get 'task/list_all'
  get 'task', to: "task#list"
  get 'task/list_today'
  get 'task/create', to: "task#create_form"
  post 'task/create'
  patch 'task/check/:id', to:"task#check"
  delete 'task/delete/:id', to:"task#delete"
  get 'task/update/:id', to:"task#update_form"
  post 'task/update', to: "task#update" #CHANGE TO PATCH ON FUTURE
  get 'task/search', to: "task#read_by_tag"

  get 'project', to: "project#list"
  get 'project/create', to: "project#create_form"
  post 'project/create'
  get 'project/:id', to: "project#task_list"
  delete 'project/delete/:id', to: "project#delete"
  get 'project/update/:id', to: "project#update_form"
  post 'project/update', to: "project#update" #CHANGE TO PATCH ON FUTURE


  #get '*path', to: "application#page_not_found"

end
