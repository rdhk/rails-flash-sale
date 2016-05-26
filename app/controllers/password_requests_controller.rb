class PasswordRequestsController < ApplicationController

  #FIXME_AB: we need to ensure that user is not logged in to access. before_action :ensure_anonymous

  def new
  end

  def create
    user = User.find_by_email(params[:password_request][:email])
    if(user) #FIXME_AB: User should be verified
      #FIXME_AB: user.fulfil_forgot_password_request
      user.handle_forgot_password
      redirect_to root_path, notice: "Password reset link has been sent on your email."
    else
      redirect_to new_password_request_path, notice: "Invalid email."
    end
  end

end
