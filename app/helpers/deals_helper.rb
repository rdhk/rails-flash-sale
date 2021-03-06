module DealsHelper

  def expired_or_soldout_button(deal)
    if deal.expired?
      '<span class="label label-danger">EXPIRED</span>'.html_safe
    elsif deal.sold_out?
      '<span class="label label-danger">SOLD OUT</span>'.html_safe
    end
  end

  def loyalty_discount_price(deal)
    if(signed_in? && deal.live)
      loyalty_discount_rate = current_user.loyalty_discount_rate
      if loyalty_discount_rate > 0
        loyalty_discount_price = number_to_currency(deal.loyalty_discount_price(loyalty_discount_rate), unit: "₹")
        "<h3 class='text-success'> FOR YOU: #{loyalty_discount_price}</h3><h4 class='text-danger'>(Additional #{loyalty_discount_rate}% loyalty discount)</h4>".html_safe
      end
    end
  end

  def buynow_or_expired_or_soldout_button(deal)
    if deal.expired?
      '<span class="label label-danger" data-behaviour="deal_state">EXPIRED</span>'.html_safe
    elsif deal.sold_out?
      '<span class="label label-danger" data-behaviour="deal_state">SOLD OUT</span>'.html_safe
    elsif signed_in? && current_pending_order && current_pending_order.deals.include?(deal)
      link_to "Checkout", checkout_order_path(current_pending_order), class: "btn btn-primary", :data => { :behaviour => 'deal_state' }
    else
      (link_to "Buy now", add_item_orders_path(deal: deal) , method: :post, class: "btn btn-success", :data => { :behaviour => 'deal_state' })
    end

  end
end
