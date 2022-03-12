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
        print(@tasks)
        respond_to do |format|
            format.html { render template: 'tasks/list', layout: 'layouts/application', status: 200}
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

    def create
        @task = Task.new
        @task.title = task_params["title"]
        @task.description = task_params["description"]
        @task.priority = task_params["priority"]
        @task.dateCreation = DateTime.current
        @task.dateDeadLine = DateTime.current
        @task.done = false

        #es necesario comprobar si el proyecto existe o no
        #@project = Project.find(params[:projectId])

        #@task[:project_id] = @project[:id]
        
        @task.save
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
        #comprobar si existe
        Task.find(params[:id]).destroy
    end
end
