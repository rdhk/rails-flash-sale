class OrdersController < ApplicationController

  before_action :authenticate
  #FIXME_AB: you can merge these two in one :ensure_deal_is_purchasable - done
  before_action :ensure_deal_is_purchasable, only: [:add_item]
  before_action :ensure_deal_not_in_cart, only: [:add_item]
  # before_action :ensure_order_purchasable, only: [:checkout, :charge]
  before_action :check_valid_line_item, only: [:remove_item]
  before_action :check_valid_order, only: [:checkout, :charge]
  before_action :check_order_exists, only: [:show]

  def index
  end

  def show
    if @order.paid?
      render 'order_summary'
    end
  end

  def remove_item
    #FIXME_AB: get_current_order is not needed - done
    @removal_success = @order.remove_item(@line_item)
  end

  def add_item
    #FIXME_AB: before_action - done

    if @order.add_item(@deal)
      #FIXME_AB: redirect to show - done
      redirect_to order_path(@order)
    else
      flash[:errors] = @order.errors.full_messages
      redirect_to deal_path(@deal)
    end
  end

  def checkout
    @total = @order.total_amount
    #FIXME_AB: before_action - done
  end

  def charge
    begin

      #FIXME_AB: do it in before_action - done


      #FIXME_AB: @order.total_ammount_paise - done
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

      #FIXME_AB: order.payment_transaction.build - done
      # payment_transaction = current_user.payment_transactions.create(get_transaction_params(charge))

      #FIXME_AB: pass transaction info to mark paid. and create transaction in mark_paid - done
      if @order.mark_paid(get_transaction_params(charge))
        #FIXME_AB: redirect user to order's show page
        redirect_to order_path(@order), notice: "Successful payment"
      else
        # refund and display cart page, with error / message - done
        Stripe::Refund.create(
          #FIXME_AB: use charge object not payment_transaction - done
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
      #FIXME_AB: this should be before action -done
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
    #FIXME_AB: @order = current_user.orders.pending.first - done
    @order = current_user.orders.pending.first
    @line_item = @order.line_items.find_by(id: params[:line_item])
    if @line_item.nil?
      redirect_to root_path, alert: "Sorry, this item does not exist in your cart."
    end
  end

  def ensure_deal_not_in_cart
    @order = current_user.get_current_order
    #FIXME_AB: before_action - done
    if @order.deals.include?(@deal)
      redirect_to deal_path(@deal), alert: "Deal already in your cart"
    end
  end

  def check_valid_order
    #FIXME_AB: eager load required data
    @order = current_user.orders.pending.find_by(id: params[:id])
    if @order.nil?
      redirect_to root_path, alert: "Order does not exist"
    elsif(@order.invalid?)
      flash[:errors] =  @order.errors.full_messages
      redirect_to order_path(@order)
    end
    #FIXME_AB: order valid? will come here - done
  end

end
