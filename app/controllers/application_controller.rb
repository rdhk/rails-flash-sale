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
    elsif(cookies[:remember_me_token].present?)
      User.find_by_remember_me_token(cookies[:remember_me_token])
      #FIXME_AB: sign_in(user)
    end
  end

  #FIXME_AB: we call it authenticate
  def require_user
    #FIXME_AB: use url_helpers
    redirect_to '/login' unless current_user
    #FIXME_AB: always set flash message when redirect
  end

end

