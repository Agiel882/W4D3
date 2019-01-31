class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :check_ownership, :check_request_ownership
  
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end 

  def logged_in?
    !!current_user
  end 

  def login_redirect
    redirect_to cats_url if logged_in?
  end

  def must_be_logged_in
    redirect_to cats_url unless logged_in?
  end 

  def login_user!
    user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    if user
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to cats_url
    end
  end

  def check_ownership
    redirect_to cats_url unless params[:id].to_i == current_user.id
  end 

  def check_request_ownership
    request = CatRentalRequest.find(params[:id])
    redirect_to cats_url unless request.cat.user_id == current_user.id 
  end

end
