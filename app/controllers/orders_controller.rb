class OrdersController < ApplicationController

  before_action :authenticate
  #FIXME_AB: you can merge these two in one :ensure_deal_is_purchasable
  before_action :check_valid_deal, only: [:add_item]
  before_action :ensure_deal_available, only:[:add_item]
  before_action :check_valid_line_item, only: [:remove_item]
  before_action :check_valid_order, only: [:checkout, :charge]

  def index
  end

  def show
    @order = current_user.orders.find_by(id: params[:id])
    if @order.paid?
      render 'order_summary'
    elsif @order.nil?
      #FIXME_AB: this should be before action
      redirect_to root_path, alert: "Order does not exist"
    end
  end

  def remove_item
    #FIXME_AB: get_current_order is not needed
    @order = current_user.get_current_order
    @removal_success = @order.remove_item(@line_item)
  end

  def add_item
    #FIXME_AB: before_action
    @order = current_user.get_current_order
    #FIXME_AB: before_action
    if @order.deals.include?(@deal)
      redirect_to deal_path(@deal), alert: "Deal already in your cart"
      return
    end

    if @order.add_item(@deal)
      #FIXME_AB: redirect to show
      render 'show'
    else
      flash[:errors] = @order.errors.full_messages
      redirect_to deal_path(@deal)
    end
  end

  def checkout
    if(@order.valid?)
      @total = @order.total_amount
    else
      #FIXME_AB: before_action
      flash[:errors] =  @order.errors.full_messages
      redirect_to order_path(@order)
    end
  end

  def charge
    begin

      #FIXME_AB: do it in before_action
      if(!@order.valid?)
        flash[:errors] =  @order.errors.full_messages
        redirect_to order_path(@order)
        return
      end

      #FIXME_AB: @order.total_ammount_paise
      @amount = @order.total_amount * 100

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

      #FIXME_AB: order.payment_transaction.build
      payment_transaction = current_user.payment_transactions.create(get_transaction_params(charge))

      #FIXME_AB: pass transaction info to mark paid. and create transaction in mark_paid
      if @order.mark_paid
        #FIXME_AB: redirect user to order's show page
        redirect_to root_path, notice: "Successful payment"
      else
        # refund and display cart page, with error / message
        Stripe::Refund.create(
          #FIXME_AB: use charge object not payment_transaction
          charge: payment_transaction.charge_id
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
      order_id: @order.id,
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

  def check_valid_deal
    @deal = Deal.live.find_by(id: params[:deal])
    if @deal.nil?
      redirect_to root_path, alert: "Sorry, invalid deal."
    end
  end

  def check_valid_line_item
    #FIXME_AB: @order = current_user.orders.pending.first
    @line_item = current_user.orders.pending.first.line_items.find_by(id: params[:line_item])
    if @line_item.nil?
      redirect_to root_path, alert: "Sorry, this item does not exist in your cart."
    end
  end

  def check_valid_order
    #FIXME_AB: eager load required data
    @order = current_user.orders.pending.find_by(id: params[:id])
    if @order.nil?
      redirect_to root_path, alert: "Order does not exist"
    end
    #FIXME_AB: order valid? will come here
  end

  def ensure_deal_available
    if @deal.sold_out?
      redirect_to root_path, alert: "Sorry, the deal has been sold out."
    end
  end
end
