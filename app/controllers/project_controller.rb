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

    def create
        @project = Project.new(project_params)

        respond_to do |format|
            if @project.save
                format.json { render :show, status: :created, location: @project }
            else
                format.json { render json: @project.errors, status: :unprocessable_entity }
            end
        end
    end

    def project_params
        params.require(:project).permit(:id, :title, :description)
    end
end
