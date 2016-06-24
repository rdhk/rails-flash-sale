class Admin::DealsController < Admin::BaseController

  before_action :set_deal, only: [:edit, :update, :show, :unpublish, :publish, :destroy]

  def index
    @deals = Deal.includes(:creator, :publisher)
  end

  def show
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = current_user.created_deals.build(deal_params)
    @deal.set_publisher(current_user)
    if @deal.save
      redirect_to admin_deal_path(@deal), notice: "Deal successfully created"
    else
      @deal.images = []
      render action: 'new'
    end
  end

  def update
    @deal.set_publisher(current_user)
    # debugger
    if @deal.update(deal_params)
      redirect_to admin_deal_path(@deal), notice: "Deal successfully updated."
    else
    @deal.images = @deal.images.select { |img| img.file_file_size.present? }
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

  def revenue_report
    @deals =  Deal.past_publishable.includes(:line_items).group(:id).order("sum(line_items.discounted_price) desc").references(:line_items)
  end

  def potential
    @deals = Deal.past_publishable
  end

  private


  def deal_params
    params.require(:deal).permit(:title, :description, :price, :discounted_price, :quantity, :publish_date, :publishable, images_attributes: [:file, :id, :_destroy])
  end

  def set_deal
    @deal = Deal.find_by(id: params[:id])
    if @deal.nil?
      redirect_to admin_deals_path, alert: "Sorry, deal not found."
    end
  end

end
