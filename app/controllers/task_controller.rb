class TaskController < ApplicationController
    protect_from_forgery with: :null_session

    def read_one
        @task = Task.find(params[:projectId])
    end

    def list
        @tasks = Task.all
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
        @task = Task.new(task_params)

        #es necesario comprobar si el proyecto existe o no
        @project = Project.find(params[:projectId])

        @task[:project_id] = @project[:id]
        
        @task.save
    end

    def task_params
        params.require(:task).permit(:id, :title, :description, :priority, :projectId)
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
