class UsersController < ApplicationController
    protect_from_forgery with: :null_session
    def new
        @user = User.new
      end
      
    def create
        @user = User.new
        @user.username=params[:username]
        @user.Email=params[:Email]
        @user.PassWord=params[:PassWord]
        if @user.save
          flash[:notice] = "User created."
          redirect_to root_path
        else
          render 'new'
        end
      end
end