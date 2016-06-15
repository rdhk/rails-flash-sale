class OrdersController < ApplicationController

  before_action :authenticate
  before_action :ensure_deal_is_purchasable, only: [:add_item]
  before_action :ensure_deal_not_in_cart, only: [:add_item]
  before_action :check_valid_line_item, only: [:remove_item]
  before_action :check_valid_order, only: [:checkout, :charge]
  before_action :check_order_exists, only: [:show]

  def index
  end

  def show
    #FIXME_AB: move this to show.html.erb
    if @order.paid?
      render 'order_summary'
    end
  end

  def remove_item
    @removal_success = @order.remove_item(@line_item)
  end

  def add_item
    if @order.add_item(@deal)
      #FIXME_AB: flash message
      redirect_to order_path(@order)
    else
      flash[:errors] = @order.errors.full_messages
      redirect_to deal_path(@deal)
    end
  end

  def checkout
    #FIXME_AB: use @order.total_amount directly
    @total = @order.total_amount
  end

  def charge
    begin
      @amount = @order.total_amount_paise

      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => "#{customer.email} purchased deals worth Rs #{@amount} for order number #{@order.id}",
        :currency    => 'inr',
        :metadata => {:email => customer.email}
      )

      if @order.mark_paid(get_transaction_params(charge))
        redirect_to order_path(@order), notice: "Successful payment"
      else
        #FIXME_AB: test refund as discussed
        Stripe::Refund.create(
          charge: charge.id
        )
        redirect_to order_path(@order), alert: "Payment failed, you have been refunded."
      end

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to checkout_order_path
    end
  end

  private

  def get_transaction_params(charge)
    {
      user_id: current_user.id,
      charge_id: charge.id,
      stripe_token: params[:stripeToken],
      amount: charge.amount,
      currency: charge.currency,
      stripe_customer_id: charge.customer,
      description: charge.description,
      stripe_email: params[:stripeEmail],
      stripe_token_type: params[:stripeTokenType]
    }
  end

  def check_order_exists
    @order = current_user.orders.find_by(id: params[:id])
    if @order.nil?
      redirect_to root_path, alert: "Order does not exist"
    end
  end

  def ensure_deal_is_purchasable
    @deal = Deal.live.find_by(id: params[:deal])
    if @deal.nil?
      redirect_to root_path, alert: "Sorry, invalid deal."
    elsif @deal.sold_out?
      redirect_to root_path, alert: "Sorry, the deal has been sold out."
    end
  end

  def check_valid_line_item
    @order = current_pending_order
    @line_item = @order.line_items.find_by(id: params[:line_item])
    if @line_item.nil?
      redirect_to root_path, alert: "Sorry, this item does not exist in your cart."
    end
  end

  def ensure_deal_not_in_cart
    @order = current_user.get_current_order
    if @order.deals.include?(@deal)
      redirect_to deal_path(@deal), alert: "Deal already in your cart"
    end
  end

  def check_valid_order
    @order = current_user.orders.pending.find_by(id: params[:id])
    if @order.nil?
      redirect_to root_path, alert: "Order does not exist"
    elsif(@order.invalid?)
      flash[:errors] =  @order.errors.full_messages
      redirect_to order_path(@order)
    end
  end

end
