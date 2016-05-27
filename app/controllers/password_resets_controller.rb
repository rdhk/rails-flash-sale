class PasswordResetsController < ApplicationController

  before_action :ensure_user_and_token_valid, only: [:new, :create]

  def new
  end

  def create
    if @user.change_password(params[:password_reset][:password], params[:password_reset][:password_confirmation])
      redirect_to root_url, notice: "Your password has been successfully changed."
    else
      params[:token] = params[:password_reset][:token]
      render 'new'
    end
  end

  private

  def ensure_user_and_token_valid
    token = (params[:token] ? params[:token] : params[:password_reset][:token])
    @user = User.find_by_password_change_token(token) if token
    if (@user.nil? || !@user.has_valid_password_token?)
      redirect_to new_password_request_path, alert: "Sorry, invalid link."
    end
  end

end
