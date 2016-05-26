class PasswordRequestsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:password_request][:email])
    if(user)
      user.handle_forgot_password
      redirect_to root_path, notice: "Password reset link has been sent on your email."
    else
      redirect_to new_password_request_path, notice: "Invalid email."
    end
  end

end
