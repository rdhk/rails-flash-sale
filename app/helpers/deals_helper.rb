module DealsHelper

  def expired?(deal)
    (deal.publish_date < Date.today) ? '<span class="label label-danger">EXPIRED</span>'.html_safe : ''
  end

  def buynow_or_expired_button(deal)
    #FIXME_AB: use url helpers always
    (deal.publish_date < Date.today) ? '<span class="label label-danger">EXPIRED</span>'.html_safe : (link_to "Buy now", {:controller => "orders", :action => "add_item", :deal => deal.id }, method: :post, class: "btn btn-success")
  end
end
