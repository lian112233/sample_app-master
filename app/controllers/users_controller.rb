class UsersController < ApplicationController
	include SessionsHelper
	before_action :logged_in_user,only: [:index,:edit, :update, :destroy]
	before_action :correct_user  ,only: [:edit, :update]
	before_action :admin_user    ,only: :destroy
  def new
  	@user = User.new()
  end

  def show
		@user = User.find(params[:id])
	end

	def create
		@user = User.new(user_params)
		if @user.save
			log_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to user_url(@user)
		else
			render 'new'
		end
	end

  def destroy
	  User.find(params[:id]).destroy()
	  flash[:success] = "User deleted"
	  redirect_to users_url
  end

  def edit
	  @user = User.find(params[:id])
  end

  def update
	  @user = User.find(params[:id])
	  if @user.update(user_params)
	  	flash[:success] = "Profile updated"
	  	redirect_to @user
	  else
	  	render 'edit'
	  end
  end

	def user_params
				params.require(:user).permit(:name, :email, :password,
																			:password_confirmation)
	end

  def index
  	@users = User.paginate(page: params[:page])
  end

	def logged_in_user
		unless  logged_in?
			store_location
			flash[:danger] = "Please log in."
			redirect_to login_url
		end
	end
  
  def correct_user
	  @user = User.find(params[:id])
	  redirect_to(root_url) unless current_user?(@user)
  end
  
  def redirect_back_or(default)
	  redirect_to(session[:forwarding_url] || default)
	  session.delete(:forwarding_url)
  end
  
  def store_location
	  session[:forwarding_url] = request.original_url if request.get?
  end
  
  def admin_user
  	redirect_to(root_url) unless  current_user.admin?
  		
  	
  end

  private:admin_user
  private:logged_in_user
	private:user_params
end
