class SessionsController < ApplicationController
  before_action :ensure_anonymous, only:[:new, :create]
  before_action :authenticate, only: [:destroy]

  def new
  end

  def create
    @user = User.verified.where(email: params[:session][:email]).first
    if(@user && @user.authenticate(params[:session][:password]))
      sign_in(@user, params[:session][:remember_me])
      redirect_to root_path, notice: "You have been successfully logged in."
    else
      redirect_to login_path, alert: "Invalid username/password combination."
    end
  end

  def destroy
    reset_session
    current_user.clear_remember_token!
    cookies.delete :remember_me_token
    redirect_to root_path, notice: "You have been successfully logged out."
  end

end
