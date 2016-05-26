class SessionsController < ApplicationController
  #FIXME_AB: new and create shoudl be accesssible to non loggedin user
  #FIXME_AB: destroy shoudl be accessablee to logged inuser

  def new
  end

  def create
    #FIXME_AB: User.verified.where(email: params[:session][:email])
    @user = User.find_by_email(params[:session][:email])
    #FIXME_AB: if @user && @user.authe....
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

  #FIXME_AB:
  # def create
  #   @user = User.verified.where(email: params[:session][:email])
  #   if @user && @user.auth...
  #     sign_in(user, params[:session][:remember_me])
  #     success message and redirect_to
  #   else
  #     failed login_path
  #   end
  # end

  # def sign_in(user, remember_me = false)
  #   session[:user_id] = user.id
  #   if remember_me
  #     user.generate_token_and_save(:remember_me_token)
  #     set cookies
  #   end
  # end



def destroy
  #FIXME_AB:
  # reset_session
  # cookies[:remember_me_token] = { :value => nil, :expires => 1.day.ago },
  # current_user.clear_remember_token! if signed_in?

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
