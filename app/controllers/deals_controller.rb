class DealsController < ApplicationController

  before_action :set_deal, only: [:show]

  def index
    @deals = Deal.live.includes(:images)
    if(@deals.blank?)
      @deals = Deal.recent_past_deals.includes(:images)
    end
  end

  def show
  end


end
