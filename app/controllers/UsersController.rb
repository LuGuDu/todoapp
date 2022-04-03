class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :permission
  before_action :authenticated, except : [:new, :create]

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

  def new
    @user = User.new
  end

  def list
    @users = User.all
    respond_to do |format|
      format.html { render template: 'users/list', layout: 'layouts/application', status: 200}
    end
  end

  def delete
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to "/user"
    else
    end
  end

  def update_form
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render template: 'users/update', layout: 'layouts/application', status: 200}
    end
  end

  def update
    @user = User.find(params[:id])
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.role = params[:role]

    if @user.save
        redirect_to "/user"
    else
        #redirect_to "/project"
    end
  end

  def create_form
    respond_to do |format|
      format.html { render template: 'users/create', layout: 'layouts/application', status: 200}
    end
  end

  def create_from_admin
    @user = User.new
    @user.username=params[:username]
    @user.email=params[:email]
    @user.role=params[:role]
    @user.password=params[:password]
    @user.password_confirmation=params[:password_confirmation]

    if @user.save
      session[:user_id]=@user.id
      flash[:notice] = "User created."
      redirect_to '/user'
    else
      render 'new'
    end
  end
        
  def create
    @user = User.new
    @user.username=params[:username]
    @user.email=params[:email]
    @user.role="normal"
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
