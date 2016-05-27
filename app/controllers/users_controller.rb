class UsersController < ApplicationController

  before_action :ensure_anonymous

  def new
    @user = User.new
  end

  def activate
    user = User.find_by_verification_token(params[:token])

    if(user && user.valid_authenticity_token?)
      sign_in(user)
      user.mark_verified!
      redirect_to root_path, notice: "Your account has been verified and you are now logged in."
    else
      redirect_to root_path, notice: "Sorry, expired link."
    end

  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "Your signup was successful, we have sent you an email verification email, please check your email and verify to continue."
    else
      render action: 'new'
    end
  end

  private


  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
