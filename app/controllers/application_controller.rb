class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= find_current_user
  end

  def find_current_user
    # debugger
    if session[:user_id]
      User.find(session[:user_id])
    elsif(!cookies[:remember_me_token].blank?)
      User.find_by_remember_me_token(cookies[:remember_me_token])
    end
  end

  def require_user
    redirect_to '/login' unless current_user
  end

end

