class OrdersController < ApplicationController

  before_action :authenticate

  def index
  end

  def new

  end

  def create
     @order = current_user.orders.build
     deal = Deal.find_by(id: params[:deal_id])

     if(deal.nil?)
      redirect_to root_path, alert: "Sorry, deal not found."
     end

     @order.line_items.build(deal_id: params[:deal_id])
     if(@order.save)
      redirect_to order_path(@order)
    end
  end

  def show
    @order = Order.find_by(id: params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
