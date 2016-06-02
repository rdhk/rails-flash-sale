class Admin::DealsController < Admin::BaseController

  before_action :set_deal, only: [:edit, :update, :show, :unpublish, :publish, :destroy]

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
    @deal.set_creator(current_user)
    @deal.set_publisher(current_user)
    # assign_creator_publisher
    if @deal.save
      redirect_to admin_deal_path(@deal), notice: "Deal successfully created"
    else
      render action: 'new'
    end
  end

  def update
    @deal.set_publisher
    if @deal.update(deal_params)
      redirect_to admin_deal_path(@deal), notice: "Deal successfully updated."
    else
      render action: 'edit'
    end
  end

  def edit

  end

  def destroy
    if @deal.destroy
      flash[:notice] = @deal.title + " was successfully destroyed."
    else
      flash[:errors] = @deal.errors.full_messages
    end
    redirect_to admin_deals_path
  end

  def unpublish
    @unpublish_success = @deal.unpublish
  end

  def publish
    @publish_success = @deal.publish(current_user)
  end

  private


  # def assign_creator_publisher
  #   @deal.creator = current_user
  #   assign_publisher
  # end

  # def assign_publisher
  #   if(params[:deal][:publishable] == "1")
  #     @deal.publisher = current_user
  #   end
  # end


  def deal_params
    params.require(:deal).permit(:title, :description, :price, :discounted_price, :quantity, :publish_date, :publishable)
  end

  def set_deal
    @deal = Deal.find_by_id(params[:id])
    if @deal.nil?
      redirect_to admin_deals_path, alert: "Sorry, deal not found."
    end
  end

end
