class OrdersController < ApplicationController

  before_action :authenticate
  before_action :ensure_deal_is_purchasable, only: [:add_item]
  before_action :ensure_deal_not_in_cart, only: [:add_item]
  before_action :check_valid_line_item, only: [:remove_item]
  before_action :check_valid_order, only: [:checkout, :charge, :preview]
  before_action :set_order_address, only: [:preview]
  before_action :check_order_exists, only: [:show]

  def index
    @orders = current_user.orders
  end

  def show
  end

  def remove_item
    @removal_success = @order.remove_item(@line_item)
  end

  def add_item
    if @order.add_item(@deal)
      redirect_to order_path(@order), notice: "#{@deal.title} has been successfully added to your cart."
    else
      flash[:errors] = @order.errors.full_messages
      redirect_to deal_path(@deal)
    end
  end

  def checkout
    #FIXME_AB: @last_used_address = current_user.last_placed_order.address - done
    last_placed_order = current_user.orders.last_placed_order.first
      @last_used_address = last_placed_order.address if last_placed_order
  end

  #FIXME_AB: there will be another step preview which will ensure that address is associated with the order - done
  def preview

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
      debugger
      if @order.mark_paid(get_transaction_params(charge, customer))
        redirect_to order_path(@order), notice: "Successful payment"
      else
        #FIXME_AB: test refund as discussed
        refund_object = Stripe::Refund.create(
          charge: charge.id
        )
        @order.payment_transactions.create(get_refund_transaction_params(refund_object, customer))
        redirect_to order_path(@order), alert: "Payment failed, you have been refunded."
      end

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to checkout_order_path
    end
  end

  private

  def get_transaction_params(charge, customer)
    {
      user_id: current_user.id,
      charge_id: charge.id,
      stripe_token: params[:stripeToken],
      amount: charge.amount,
      currency: charge.currency,
      stripe_customer_id: charge.customer,
      description: charge.description,
      stripe_email: params[:stripeEmail],
      stripe_token_type: params[:stripeTokenType],
      card_number_last4: customer.sources.data[0]["last4"].to_i,
      card_name: customer.sources.data[0]["brand"],
      expiry_month: customer.sources.data[0]["exp_month"].to_i,
      expiry_year: customer.sources.data[0]["exp_year"].to_i
    }
  end

  def get_refund_transaction_params(refund, customer)
    {
      user_id: current_user.id,
      refund_id: refund.id,
      charge_id: refund.charge,
      amount: refund.amount,
      currency: refund.currency,
      description:"#{customer.email} was refunded Rs #{@amount} for order number #{@order.id}",
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

  def set_order_address
    @address = current_user.addresses.find_by(id: params[:user][:address]) if params[:user]
    if @address.nil?
      redirect_to checkout_order_path(@order), alert: "Invalid Address"
    else
      @order.address = @address
      @order.save
    end
  end

end
