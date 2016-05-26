class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:session][:email])
    if(@user && @user.is_valid?(params[:session][:password]))
      # debugger
      if(params[:session][:remember_me] == "1")
        @user.generate_token_and_save(:remember_me_token)
        cookies.permanent[:remember_me_token] = @user.remember_me_token
      else
        session[:user_id] = @user.id
      end
      redirect_to root_path, notice: "You have been successfully logged in."
    else
      redirect_to login_path, alert: "Invalid username/password combination."
    end
  end

def destroy
  if(cookies[:remember_me_token].blank?)
    reset_session
  else
    user = User.find_by_remember_me_token(cookies[:remember_me_token])
    user.clear_remember_token
    cookies[:remember_me_token] = nil
  end
  redirect_to root_path, notice: "You have been successfully logged out."
end

end
