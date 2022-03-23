Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")


  root "application#index"

  get 'task/list_all', to: "task#list_all"
  get 'task', to: "task#list"
  get 'task/list_today', to: "task#list_today"
  get 'task/create', to: "task#create_form"
  post 'task/create', to: "task#create"
  patch 'task/check/:id', to:"task#check"
  patch 'task/uncheck/:id', to:"task#uncheck"
  delete 'task/delete/:id', to:"task#delete"
  get 'task/update/:id', to:"task#update_form"
  post 'task/update', to: "task#update" #CHANGE TO PATCH ON FUTURE
  get 'task/search', to: "task#read_by_tag"
  
  get 'signup', to: "users#new"
  post 'signup', to: "users#create"
  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy"
  resources :users, except: [:new]

  get 'project', to: "project#list"
  get 'project/create', to: "project#create_form"
  post 'project/create', to: "project#create"
  get 'project/:id', to: "project#task_list"
  delete 'project/delete/:id', to: "project#delete"
  get 'project/update/:id', to: "project#update_form"
  post 'project/update', to: "project#update" #CHANGE TO PATCH ON FUTURE


  get '*path', to: "application#page_not_found"

end
