class TaskController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    before_action :authenticated
    before_action :permission, only: [:get_all]

    def authenticated
        if (session[:role] == nil)
          respond_to do |format|
            format.html { render template: 'errors/no_authenticated', layout: 'layouts/application', status: 401}
          end
        end
      end 
  
    def permission
      if (session[:role] == "normal")
        respond_to do |format|
          format.html { render template: 'errors/no_permission', layout: 'layouts/application', status: 403}
        end
      end
    end 

    def read_one
        @task = Task.find(params[:projectId])
    end

    def get_all
        @tasks = Task.all
        respond_to do |format|
            format.html { render template: 'tasks/list', layout: 'layouts/application', status: 200}
        end
    end

    def list_all
        @tasks = Task.where(:user_id => session[:user_id]["$oid"])
        respond_to do |format|
            format.html { render template: 'tasks/list', layout: 'layouts/application', status: 200}
        end
    end

    def list
        @tasks = Task.where(:done => 'false', :user_id => session[:user_id]["$oid"])
        
        respond_to do |format|
            format.html { render template: 'tasks/list', layout: 'layouts/application', status: 200}
        end
    end

    def check
        @task = Task.find(params[:id])
        @task.done = true
        if @task.save
            if (session[:role] == "admin")
                redirect_to "/task/all"
            else
                redirect_to "/task"
            end
        end
    end
    
    def uncheck
        @task = Task.find(params[:id])
        @task.done = false
        if @task.save
            if (session[:role] == "admin")
                redirect_to "/task/all"
            else
                redirect_to "/task"
            end
        end
    end

    def list_today
        @tasks = []
        @allTasks = Task.where(:user_id => session[:user_id]["$oid"])
        @allTasks.each do |task|
            if task.dateDeadLine <= DateTime.current
                @tasks << task
            end
        end
        respond_to do |format|
            format.html { render template: 'tasks/list', layout: 'layouts/application', status: 200}
        end
    end

    def read_by_tag
        @tasks = []
        @allTasks = Task.where(:user_id => session[:user_id]["$oid"])
        @allTasks.each do |task|
            #search by title and description
            if (task.title.include? params[:search]) || (task.description.include? params[:search]) 
                @tasks << task
            end
        end
        respond_to do |format|
            format.html { render template: 'tasks/list', layout: 'layouts/application', status: 200}
        end
    end

    def create_form
        @projects = Project.where(:user_id => session[:user_id]["$oid"])
        @users = User.all

        respond_to do |format|
            format.html { render template: 'tasks/create', layout: 'layouts/application', status: 200}
        end
    end

    def create
        @task = Task.new
        @task.title = params[:title]
        @task.description = params[:description]
        @task.priority = params[:priority]
        @task.dateCreation = DateTime.current
        @task.dateDeadLine = DateTime.strptime(params[:deadline], '%Y-%m-%d')
        @task.done = false

        if (session[:role] == "admin")
            @task.user_id = params["user_id"]
        else
            @task.user_id = session[:user_id]["$oid"]
        end

        if params[:project_id] != 'none'
            @task.project_id = params[:project_id]
        end
        
        if @task.save
            if (session[:role] == "admin")
                redirect_to "/task/all"
            else
                redirect_to "/task"
            end
        end
    end

    def update_form
        @projects = Project.where(:user_id => session[:user_id]["$oid"])
        @task = Task.find(params[:id])
        @date = @task.dateDeadLine.strftime('%Y-%m-%d')
        @user = User.find(@task.user_id)
        @users = User.all

        if @task.project_id != 'none' && @task.project_id.present?
            @projectTask = Project.find(@task.project_id)
        end

        respond_to do |format|
            format.html { render template: 'tasks/update', layout: 'layouts/application', status: 200}
        end
    end

    def update
        @task = Task.find(params[:id])
        @task.title = params[:title]
        @task.description = params[:description]
        @task.priority = params[:priority]
        @task.dateDeadLine = DateTime.strptime(params[:deadline], '%Y-%m-%d')

        @task.project_id = params[:project_id]

        if (session[:role] == "admin")
            @task.user_id = params["user_id"]
        else
            @task.user_id = session[:user_id]["$oid"]
        end
        
        if @task.save
            if (session[:role] == "admin")
                redirect_to "/task/all"
            else
                redirect_to "/task"
            end
        end

    end

    def delete
        @task = Task.find(params[:id])
        if @task.destroy
            if (session[:role] == "admin")
                redirect_to "/task/all"
            else
                redirect_to "/task"
            end
        else
        end
    end
end
