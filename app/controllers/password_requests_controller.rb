class PasswordRequestsController < ApplicationController

  before_action :ensure_anonymous

  def new
  end

  def create
    user = User.verified.where(email: params[:password_request][:email]).first
    if(user)
      user.fulfill_forgot_password_request
      redirect_to root_path, notice: "Password reset link has been sent on your email."
    else
      redirect_to new_password_request_path, notice: "Invalid email."
    end
  end

end
