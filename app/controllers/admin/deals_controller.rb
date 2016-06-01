class Admin::DealsController < Admin::BasesController

  before_action :set_deal, only: [:edit, :update, :show, :unpublish, :publish]

  def unpublish
    sleep 2
    @unpublish_success = @deal.unpublish
    #FIXME_AB: - done
  end

  def publish
    sleep 2
    @publish_success = @deal.publish
    #FIXME_AB: - done
  end

  def index
    @deals = Deal.all
  end

  def show
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(deal_params)

    if @deal.save
      redirect_to admin_deal_path(@deal), notice: "Deal successfully created"
    else
      render action: 'new'
    end
  end

  def update
    if @deal.update(deal_params)
      redirect_to admin_deal_path(@deal), notice: "Deal successfully updated."
    else
      render action: 'edit'
    end
  end

  def edit

  end

  def destroy
  end

  private


  def deal_params
    params.require(:deal).permit(:title, :description, :price, :discounted_price, :quantity, :publish_date, :publishable)
  end

  def set_deal
    @deal = Deal.find_by_id(params[:id])
    if(!@deal)
      redirect_to admin_deals_path, alert: "Sorry, deal not found."
    end
    @deal
      #FIXME_AB: what if deal not found - deal
  end

end
