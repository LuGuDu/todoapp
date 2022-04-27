class NotificationController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    before_action :authenticated
    before_action :permission, only: []

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
        if (session[:role] == "admin")
            @notifications = Notification.where(:state => 'WAITING').or(Notification.where(:state => 'CLOSED'))
        else
            @notifications = Notification.where(:state => 'WAITING', :dest_user_id => session[:user_id]["$oid"])
            .or(Notification.where(:state => 'CLOSED', :dest_user_id => session[:user_id]["$oid"]))
        end

        respond_to do |format|
            format.html { render template: 'notifications/list', layout: 'layouts/application', status: 200}
        end
    end

    def view
        @notification = Notification.find(params[:id])
        @notification.state = "VIEW"
        if @notification.save
            redirect_to "/notifications"
        end
    end

    def accept
        @notification = Notification.find(params[:id])
        @notification.state = "ACCEPT"
        if @notification.save
            
            @response = Notification.new

            @response.project_id = @notification.project_id
            @response.dest_user_id = @notification.origin_user_id
            @response.origin_user_id = @notification.dest_user_id
    
            @project = Project.find(@response.project_id)
            @user = User.find(@response.origin_user_id)
    
            @response.message =  @user.username << " " << @notification.state << "S " << @project.title << " PROJECT"
            @response.state = "CLOSED"
    
            @response.save

            redirect_to "/notifications"
        end
    end

    def decline
        @notification = Notification.find(params[:id])
        @notification.state = "DECLINE"
        if @notification.save
            
            @response = Notification.new

            @response.project_id = @notification.project_id
            @response.dest_user_id = @notification.origin_user_id
            @response.origin_user_id = @notification.dest_user_id
    
            @project = Project.find(@response.project_id)
            @user = User.find(@response.origin_user_id)
    
            @response.message =  @user.username << " " << @notification.state << "S " << @project.title << " PROJECT"
            @response.state = "CLOSED"
    
            @response.save

            redirect_to "/notifications"
        end
    end
end
