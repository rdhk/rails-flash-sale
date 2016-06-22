class Api::OrdersController < ApplicationController

  before_action :ensure_authenticated_user
  def index
    @orders = @user.orders.placed
  end

  private

  def ensure_authenticated_user
    @user = User.find_by(auth_token: params[:token])
    if @user.nil?
      redirect_to root_path, alert: "Sorry, invalid user."
    end
  end

end
