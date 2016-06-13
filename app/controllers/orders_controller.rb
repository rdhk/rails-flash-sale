class OrdersController < ApplicationController

  before_action :authenticate
  before_action :check_valid_deal, only: [:add_item]
  before_action :check_valid_line_item, only: [:remove_item]

  def index
  end

  def remove_item
    @order = current_user.get_current_order
    @removal_success = @order.remove_item(@line_item)
  end

  def add_item
    @order = current_user.get_current_order
    if @order.add_item(@deal)
      render 'show'
    else
      redirect_to order_path(@order), alert: "#{@deal.title} already added to cart or purchased by you."
    end
  end

  def checkout
    #FIXME_AB: user can checkout any order?
    @order = Order.find(params[:id])
    @total = @order.calculate_total
  end

  #FIXME_AB: rename this action to "charge" its an action not a state. 
  def paid
    @order = Order.find(params[:id])
    @amount = @order.calculate_total*100

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      #FIXME_AB: Use better description
      :description => 'Rails Stripe customer',
      :currency    => 'inr',
      :metadata => {:email => customer.email}
    )

    #FIXME_AB: need to lot of things here, record bought qty, validate order/deal else refune
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to checkout_order_path
  end
end

private

def check_valid_deal
  @deal = Deal.live.find_by(id: params[:deal])
  if @deal.nil?
    redirect_to root_path, alert: "Sorry, invalid deal."
  end
end

def check_valid_line_item
  @line_item = LineItem.find_by(id: params[:line_item])
  if @line_item.nil?
    redirect_to root_path, alert: "Sorry, this item does not exist in your cart."
  end
end
