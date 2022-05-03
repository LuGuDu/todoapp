class ProjectController < ApplicationController
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

    def list
        @projects = Project.where(:user_id => session[:user_id]["$oid"])

        respond_to do |format|
            format.html { render template: 'projects/list', layout: 'layouts/application', status: 200}
        end
    end

    def get_all
        @projects = Project.all
        respond_to do |format|
            format.html { render template: 'projects/list', layout: 'layouts/application', status: 200}
        end
    end

    def shared_list
        @projects = []
        @notifications = Notification.where(:dest_user_id => session[:user_id]["$oid"], :state => "ACCEPT")
        @notifications.each do |notification|
            puts(notification.message)
            @projects << Project.find(notification.project_id)
        end

        respond_to do |format|
            format.html { render template: 'projects/listShared', layout: 'layouts/application', status: 200}
        end
    end

    def add_task_form
        @users = User.all
        @project = Project.find(params[:project_id])
        respond_to do |format|
            format.html { render template: 'tasks/addTask', layout: 'layouts/application', status: 200}
        end
    end

    def add_task
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

            @notifications = Notification.where(:project_id => params[:project_id], :state => 'ACCEPT')
            @user = User.find(session[:user_id]["$oid"])
            @project = Project.find(params[:project_id])

            @notifications.each do |notification|
                @userDest = User.find(notification.dest_user_id)
    
                @notification = Notification.new
                @notification.origin_user_id = session[:user_id]["$oid"]
                @notification.dest_user_id = @userDest.id
                @notification.message =  @user.username + " ADDED A TASK TO " + @project.title + " PROJECT"
                @notification.state = "CLOSED"
                @notification.project_id = params[:project_id]
                @notification.save

                @userOr = User.find(notification.origin_user_id)

                @notification2 = Notification.new
                @notification2.origin_user_id = session[:user_id]["$oid"]
                @notification2.dest_user_id = @userOr.id
                @notification2.message =  @user.username + " ADDED A TASK TO  " + @project.title + " PROJECT"
                @notification2.state = "CLOSED"
                @notification2.project_id = params[:project_id]
                @notification2.save
            end

            redirect_to "/project/" << params[:project_id]
        end
    end

    def task_list
        @project = Project.find(params[:id])
        @tasks = Task.where(:project_id => params[:id])
        respond_to do |format|
            format.html { render template: 'projects/listTasks', layout: 'layouts/application', status: 200}
        end
    end

    def new
        @project = Project.new
    end
    
    def create_form
        @users = User.all
        respond_to do |format|
            format.html { render template: 'projects/create', layout: 'layouts/application', status: 200}
        end
    end

    def create
        user_id = ""
        if (session[:role] == "admin")
            user_id = params["user_id"]
        else
            user_id = session[:user_id]["$oid"]
        end

        @project = Project.new({"title"=> params["title"], "description"=> params["description"], "user_id"=> user_id, "revoke"=> false}) 
        if @project.save
            if (session[:role] == "admin")
                redirect_to "/project/all"
            else
                redirect_to "/project"
            end
        end 
    end

    def delete
        @project = Project.find(params[:id])
        if @project.destroy
            if (session[:role] == "admin")
                redirect_to "/project/all"
            else
                redirect_to "/project"
            end
        end
    end

    def update_form
        @project = Project.find(params[:id])
        @user = User.find(@project.user_id)
        @users = User.all
        respond_to do |format|
            format.html { render template: 'projects/update', layout: 'layouts/application', status: 200}
        end
    end

    def update
        @project = Project.find(params[:id])
        @project.title = params[:title]
        @project.description = params[:description]

        if (session[:role] == "admin")
            @project.user_id = params["user_id"]
        else
            @project.user_id = session[:user_id]["$oid"]
        end

        if @project.save

            @notifications = Notification.where(:project_id => params[:id], :state => 'ACCEPT')
            @user = User.find(session[:user_id]["$oid"])

            @notifications.each do |notification|
                @userDest = User.find(notification.dest_user_id)
    
                @notification = Notification.new
                @notification.origin_user_id = session[:user_id]["$oid"]
                @notification.dest_user_id = @userDest.id
                @notification.message =  @user.username + " UPDATED " + @project.title + " PROJECT"
                @notification.state = "CLOSED"
                @notification.project_id = params[:id]
                @notification.save

                @userOr = User.find(notification.origin_user_id)

                @notification2 = Notification.new
                @notification2.origin_user_id = session[:user_id]["$oid"]
                @notification2.dest_user_id = @userOr.id
                @notification2.message =  @user.username + " UPDATED " + @project.title + " PROJECT"
                @notification2.state = "CLOSED"
                @notification2.project_id = params[:id]
                @notification2.save
            end

            if (session[:role] == "admin")
                redirect_to "/project/all"
            else
                redirect_to "/project"
            end
        end
    end

    def invite_form
        @project = Project.find(params[:id])
        @users = User.all
        respond_to do |format|
            format.html { render template: 'projects/invite', layout: 'layouts/application', status: 200}
        end
    end

    def invite
        @notification = Notification.new
        @notification.project_id = params[:id]
        @notification.origin_user_id = session[:user_id]["$oid"]
        @notification.dest_user_id = params[:user_id]

        @project = Project.find(params[:id])
        @user = User.find(session[:user_id]["$oid"])

        @notification.message =  @user.username << " WANTS YOU TO ENTER TO THE " << @project.title << " PROJECT"
        @notification.state = "WAITING"

        if @notification.save
            if (session[:role] == "admin")
                redirect_to "/project/all"
            else
                redirect_to "/project"
            end
        end

    end

    def unrevoke
        @project = Project.find(params[:id])
        @project.revoke = false

        @user = User.find(session[:user_id]["$oid"])

        @notifications = Notification.where(:project_id => params[:id], :state => 'ACCEPT')

        @notifications.each do |notification|
            @userDest = User.find(notification.dest_user_id)

            @notification = Notification.new
            @notification.origin_user_id = session[:user_id]["$oid"]
            @notification.dest_user_id = @userDest.id
            @notification.message =  @user.username + " UNREVOKE " + @project.title + " PROJECT"
            @notification.state = "CLOSED"
            @notification.project_id = params[:id]
            @notification.save

            @userOr = User.find(notification.origin_user_id)

            @notification2 = Notification.new
            @notification2.origin_user_id = session[:user_id]["$oid"]
            @notification2.dest_user_id = @userOr.id
            @notification2.message =  @user.username + " UNREVOKE " + @project.title + " PROJECT"
            @notification2.state = "CLOSED"
            @notification2.project_id = params[:id]
            @notification2.save
        end

        if @project.save
            if (session[:role] == "admin")
                redirect_to "/project/all"
            else
                redirect_to "/project"
            end
        end
    end

    def revoke
        @project = Project.find(params[:id])
        @project.revoke = true

        @user = User.find(session[:user_id]["$oid"])

        @notifications = Notification.where(:project_id => params[:id], :state => 'ACCEPT')

        @notifications.each do |notification|
            @userDest = User.find(notification.dest_user_id)

            @notification = Notification.new
            @notification.origin_user_id = session[:user_id]["$oid"]
            @notification.dest_user_id = @userDest.id
            @notification.message =  @user.username + " REVOKE " + @project.title + " PROJECT"
            @notification.state = "CLOSED"
            @notification.project_id = params[:id]
            @notification.save

            @userOr = User.find(notification.origin_user_id)

            @notification2 = Notification.new
            @notification2.origin_user_id = session[:user_id]["$oid"]
            @notification2.dest_user_id = @userOr.id
            @notification2.message =  @user.username + " UNREVOKE " + @project.title + " PROJECT"
            @notification2.state = "CLOSED"
            @notification2.project_id = params[:id]
            @notification2.save
        end

        if @project.save
            if (session[:role] == "admin")
                redirect_to "/project/all"
            else
                redirect_to "/project"
            end
        end
    end
end
