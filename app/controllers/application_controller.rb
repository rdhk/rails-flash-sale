class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?, :current_pending_order

  def set_deal
    @deal = Deal.publishable.find_by(id: params[:id])
    if @deal.nil?
      redirect_to root_path, alert: "Sorry, deal not found."
    end
  end

  def ensure_anonymous
    if(signed_in?)
      redirect_to root_path, alert: "You are already signed in, the page you were trying to access is accessible to anonymous users only. You may logout and try again."
    end
  end

  def signed_in?
    current_user ? true : false
  end

  def sign_in(user, remember_me = false)
    session[:user_id] = user.id

    if remember_me == "1"
      user.generate_token_and_save(:remember_me_token)
      # set cookies
      cookies.permanent[:remember_me_token] = user.remember_me_token
    end
  end

  def current_user
    @current_user ||= find_current_user
  end

  def current_pending_order
    @current_pending_order ||= current_user.orders.pending.first
  end

  #FIXME_AB:  we don't need this here - done

  def find_current_user
    if session[:user_id]
      User.find(session[:user_id])
    elsif(cookies[:remember_me_token].present? && (user = User.find_by_remember_me_token(cookies[:remember_me_token])))
      sign_in(user)
      user
    end
  end

  def authenticate
    redirect_to login_path, alert: "Please log in first." unless signed_in?
  end

end
