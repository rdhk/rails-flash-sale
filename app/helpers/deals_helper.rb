module DealsHelper

  def expired_or_soldout_button(deal)
    if deal.expired?
      '<span class="label label-danger">EXPIRED</span>'.html_safe
    elsif deal.sold_out?
      '<span class="label label-danger">SOLD OUT</span>'.html_safe
    end
  end

  def buynow_or_expired_or_soldout_button(deal)
    #FIXME_AB: use url helpers always - done
    if deal.expired?
      '<span class="label label-danger">EXPIRED</span>'.html_safe
    elsif deal.sold_out?
      '<span class="label label-danger">SOLD OUT</span>'.html_safe
    elsif current_user && current_user.orders.pending.first && current_user.orders.pending.first.deals.include?(deal)
      link_to "Checkout", checkout_order_path(current_user.orders.pending.first), class: "btn btn-primary"
    else
      (link_to "Buy now", orders_add_item_path(:deal => deal.id) , method: :post, class: "btn btn-success")
    end

  end
end
