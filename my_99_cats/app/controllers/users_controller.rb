class UsersController < ApplicationController
  before_action :login_redirect, only: [:new]
  def new
    render :new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to cats_url
    else
      render json: user.errors.full_message
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end