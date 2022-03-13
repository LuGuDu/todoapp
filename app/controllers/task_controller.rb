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

    def list_today
    end

    def read_by_tag
        @tasks = Task.all
        #buscar en la descripcion un substring #XXX
    end

    def list_by_project
        @tasks = Task.find(params[:projectId])
        @tasks.each do |val|
            puts(val[:title])
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

    def update
        #comprobar si existe
        @task = Task.find(params[:id])
        @tasks = Task.all
    end

    def delete
        @task = Task.find(params[:id])
        if @task.destroy
            redirect_to "/task"
        else
        end
    end
end
