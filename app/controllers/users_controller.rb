include ActionView::Helpers::TextHelper


class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  before_filter :not_signed_in, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show
	 @user = User.find(params[:id])
   @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user #instead of loading success, load the user profile page
    else
      render 'new' #reloads the signup page to show all the error messages
    end
  end

  def edit
    #@user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #successful update
      flash[:success] = "Profile updated"
      sign_in @user
        #need to sign in again because the remember token gets reset
      redirect_to @user
    else
      #unsuccessful
      render 'edit'
    end
  end

  def destroy
    if !current_user?(User.find(params[:id]))
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end


  private

  # moved signed_in_user to the sessions_helper
    # so microposts controller can use it also

    def not_signed_in
      redirect_to root_path unless !signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
