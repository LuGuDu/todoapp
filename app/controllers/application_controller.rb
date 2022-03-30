class ApplicationController < ActionController::Base

    def index
      redirect_to '/login'
    end

    def page_not_found
        respond_to do |format|
          format.html { render template: 'errors/not_found_error', layout: 'layouts/application', status: 404 }
        end
    end
    
    def server_error
        respond_to do |format|
          format.html { render template: 'errors/internal_server_error', layout: 'layouts/application', status: 500 }
          format.all  { render nothing: true, status: 500}
        end
    end

    def access_error
      respond_to do |format|
        format.html { render template: 'errors/internal_server_error', layout: 'layouts/application', status: 500 }
        format.all  { render nothing: true, status: 500}
      end
  end
    
    helper_method :current_user, :logged_in?
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
      
    def logged_in?
        !!current_user
    end
      
    def require_user
        if !logged_in?
          flash[:alert] = "You must be logged in to perform that action."
          redirect_to login_path
        end
      end 
end
