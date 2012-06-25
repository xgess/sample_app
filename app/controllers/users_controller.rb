include ActionView::Helpers::TextHelper


class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
	 @user = User.find(params[:id])
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

end
