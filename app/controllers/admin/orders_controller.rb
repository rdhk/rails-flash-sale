class Admin::OrdersController < Admin::BaseController

  before_action :ensure_valid_order, except: [:index]
  before_action :ensure_paid_order, only: [:mark_delivered, :mark_cancelled]

  def index
    if params[:q]
      @orders = Order.placed.search_by_email(params[:q]).paginate(page: params[:page], per_page: 4)
    else
      @orders = Order.placed.paginate(page: params[:page], per_page: 4)
    end
  end

  def show

  end

  def mark_delivered
    if @order.mark_delivered
      redirect_to admin_order_path(@order)
    else
      redirect_to :back, alert: "Sorry, status could not be changed."
    end
  end

  def mark_cancelled
    if @order.mark_cancelled
      redirect_to admin_order_path(@order)
    else
      redirect_to :back, alert: "Sorry, status could not be changed."
    end
  end

  private

  def ensure_paid_order
    if !@order.paid?
      redirect_to :back, alert:"Sorry, the order must be paid to change its status."
    end
  end

  def ensure_valid_order
    @order = Order.placed.find_by(id: params[:id])

    if @order.nil?
      redirect_to :back, alert: "Sorry, Invalid Order."
    end

  end
end
