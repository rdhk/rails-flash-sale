class DealsController < ApplicationController

  before_action :set_deal, only: [:show]
  def index
  #FIXME_AB: eagerload images -done
    @deals = Deal.live.includes(:images)
    #FIXME_AB: use blank? - done
    if(@deals.blank?)
      @deals = Deal.recent_past_deals.includes(:images)
    end
  end

  def show
  end

  private
    def set_deal
      @deal = Deal.find_by(id: params[:id])
      if @deal.nil?
        redirect_to root_path, alert: "Sorry, deal not found."
      end
    end
end
