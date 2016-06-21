class DealsController < ApplicationController

  before_action :set_deal, only: [:show]

  def index
    @deals = Deal.live.includes(:images)
    if(@deals.blank?)
      @deals = Deal.recent_past_deals.includes(:images)
    end
  end

  def check_status
    @deal = Deal.find_by(id: params[:deal])
  end

  def past
    @deals = Deal.past_publishable.paginate(:page => params[:page], :per_page => 2)
  end

  def show
  end


end
