class Api::OrdersController < ApplicationController

  before_action :ensure_authenticated_user

  def index
    @orders = @user.orders.placed
  end

  private

  def ensure_authenticated_user
    #FIXME_AB: verified - done
    @user = User.verified.find_by(auth_token: params[:token])
    if @user.nil?
      # FIXME_AB: return json - done
      render :json => { :error => "Sorry, invalid user." }
    end
  end

end
