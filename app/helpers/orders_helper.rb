module OrdersHelper
  def paynow_or_expired_button(order)
    if(order.has_expired_items?)
      '<span class="label label-danger">EXPIRED</span>'.html_safe
    elsif(order.line_items.present?)
      link_to "Checkout", checkout_order_path(order), class: "btn btn-primary",:data => {behaviour: "checkout" }
    end
  end
end
