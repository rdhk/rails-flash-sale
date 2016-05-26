class PasswordResetsController < ApplicationController
  def new
    user = User.find_by_password_change_token(params[:token])
    if !(user && user.has_valid_password_token)
      redirect_to "password_requests/new", alert: "Sorry, invalid link."
    end
  end

  def create
    user = User.find_by_password_change_token(params[:password_reset][:token])
    if(user && user.has_valid_password_token)
      if(passwords_match?)
        user.change_password(params[:password_reset][:password])
        redirect_to root_url, notice: "Your password has been successfully changed."
      else
        redirect_to :back, alert: "Passwords dont match."
      end
    else
      redirect_to "password_requests/new", alert: "Sorry, invalid link."
    end
  end

  private

  def passwords_match?
    params[:password_reset][:password] == params[:password_reset][:password_confirmation]
  end
end
