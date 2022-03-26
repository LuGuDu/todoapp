class UsersController < ApplicationController
    protect_from_forgery with: :null_session
    def new
        @user = User.new
      end
      
    def create
        @user = User.new
        @user.username=params[:username]
        @user.email=params[:email]
        @user.password=params[:password]
        @user.password_confirmation=params[:password_confirmation]
        if @user.save
          session[:user_id]=@user.id
          flash[:notice] = "User created."
          redirect_to root_path
        else
          render 'new'
        end
      end
end