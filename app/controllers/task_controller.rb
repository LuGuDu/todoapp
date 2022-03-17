class TaskController < ApplicationController
    protect_from_forgery with: :null_session

    def read_one
        @task = Task.find(params[:projectId])
    end

    def list_all
        @tasks = Task.all
        respond_to do |format|
            format.html { render template: 'tasks/list', layout: 'layouts/application', status: 200}
        end
    end

    def list
        @tasks = Task.where(:done => 'false')
        respond_to do |format|
            format.html { render template: 'tasks/list', layout: 'layouts/application', status: 200}
        end
    end

    def check
        @task = Task.find(params[:id])
        @task.done = true
        if @task.save
            redirect_to "/task"
        else
        end
    end
    
    def uncheck
        @task = Task.find(params[:id])
        @task.done = false
        if @task.save
            redirect_to "/task"
        else
        end
    end

    def list_today
        @tasks = []
        @allTasks = Task.all
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
        @allTasks = Task.all
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
        @projects = Project.all

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

        if params[:project_id] != 'none'
            @task.project_id = params[:project_id]
        end
        
        if @task.save
            redirect_to '/task'
        end
    end

    def task_params
        params.require(:task).permit(:title, :description, :priority, :projectId)
    end

    def update_form
        @projects = Project.all
        @task = Task.find(params[:id])
        @date = @task.dateDeadLine.strftime('%Y-%m-%d')

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
        
        if @task.save
            redirect_to '/task'
        end

    end

    def delete
        @task = Task.find(params[:id])
        if @task.destroy
            redirect_to "/task"
        else
        end
    end
end
