class ProjectController < ApplicationController
    protect_from_forgery with: :null_session

    def list
        @projects = Project.all
        respond_to do |format|
            format.html { render template: 'projects/list', layout: 'layouts/application', status: 200}
        end
    end

    def new
        @project = Project.new
    end
    
    def create_form
        respond_to do |format|
            format.html { render template: 'projects/create', layout: 'layouts/application', status: 200}
        end
    end

    def create
        @project = Project.new({"title"=> params["title"], "description"=> params["description"]}) 
        if @project.save
            redirect_to "/project/list"
        else
        end
        
    end

    def delete
        @project = Project.find(params[:id])
        if @project.destroy
            redirect_to "/project/list"
        else
        end
    end

    def project_params
        params.require(:project).permit(:id, :title, :description)
    end
end
