class Api::DealsController < ApplicationController
  #FIXME_AB: eager load - done
  def live
    @deals = Deal.live.includes(:creator, :publisher)
  end

  def past
    @deals = Deal.past_publishable.includes(:creator, :publisher)
  end
end
