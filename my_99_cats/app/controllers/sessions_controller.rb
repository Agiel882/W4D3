class SessionsController < ApplicationController
  before_action :login_redirect, only: [:new]
  def create
    login_user!
  end

  def new
    render :new
  end

  def destroy
    if current_user
      current_user.reset_session_token!
    end 
      session[:session_token] = nil 

      redirect_to cats_url 
  end

end