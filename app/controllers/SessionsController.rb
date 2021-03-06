class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  def new
    @user = User.new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      session[:role] = user.role
      flash[:notice] = "Logged in successfully."

      if user.role =="normal"
        redirect_to '/task'
      else
        redirect_to '/task/all'
      end
    else
      flash.now[:alert] = "There was something wrong with your login details."
      render 'new'
    end
  end
   
  def destroy
    session[:user_id] = nil
    session[:role]= nil
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end

end