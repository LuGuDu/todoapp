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
            @notifications = Notification.all
        else
            @notifications = Notification.where(:dest_user_id => session[:user_id]["$oid"])
        end

        respond_to do |format|
            format.html { render template: 'notifications/list', layout: 'layouts/application', status: 200}
        end
    end

    def accept
        @notification = Notification.find(params[:id])
        @notification.state = "ACCEPT"
        if @notification.save
            redirect_to "/notifications"
        end
    end

    def decline
        @notification = Notification.find(params[:id])
        @notification.state = "DECLINE"
        if @notification.save
            redirect_to "/notifications"
        end
    end
end
