module DealsHelper

  def expired?(deal)
    (deal.publish_date < Date.today) ? '<span class="label label-danger">EXPIRED</span>'.html_safe : ''
  end

  def buynow_or_expired_button(deal)
    (deal.publish_date < Date.today) ? '<span class="label label-danger">EXPIRED</span>'.html_safe : (link_to "Buy now", orders_path(deal_id: params[:id]), method: :post, class: "btn btn-success")
  end
end
