class PasswordResetsController < ApplicationController

  #FIXME_AB: I think we can have a before_action to check user and token validity

  def new
    user = User.find_by_password_change_token(params[:token])
    #FIXME_AB:  if user.nil? || !user.has_valid_password_token?
    if !(user && user.has_valid_password_token)
      #FIXME_AB: url helpers
      redirect_to "password_requests/new", alert: "Sorry, invalid link."
    end
  end

  def create
    user = User.find_by_password_change_token(params[:password_reset][:token])
    # user.password_required = true
    #FIXME_AB: user.password = params[:password]
    #FIXME_AB: user.password_confirmation = params......
    #FIXME_AB: if user.change_password(pass, confrm pass)
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

  #FIXME_AB:
  # def create
  #   if user.change_password(pass, conf_pass)
  #     successfully
  #   else
  #       render :new
  #   end
  # end

  # def change_password(p, cp)
  #   self.password_required = true
  #   self.p = p
  #   self.cp = cp
  #   self.toke = nil
  #   save
  # end



  private

  #FIXME_AB: not requried
  def passwords_match?
    params[:password_reset][:password] == params[:password_reset][:password_confirmation]
  end
end
