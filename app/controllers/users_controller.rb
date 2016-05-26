class UsersController < ApplicationController


  def new
    @user = User.new
  end

  def activate
    user = User.find_by_verification_token(params[:token])

    if(user && user.valid_authenticity_token?)
      session[:user_id] = user.id
      user.mark_verified
      redirect_to root_path, notice: "Your account has been verified and you are now logged in."
    else
      redirect_to root_path, notice: "Sorry, expired link."
    end

  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User #{@user.first_name} was successfully created and an email has been sent. Please go to your email and verify your account."
    else
      render action: 'new'
    end
  end

  private


  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
