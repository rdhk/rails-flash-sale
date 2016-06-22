class Api::DealsController < ApplicationController
  def live
    @deals = Deal.live
  end

  def past
    @deals = Deal.past_publishable
  end
end
