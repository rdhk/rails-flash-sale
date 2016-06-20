module OrdersHelper
  def paynow_or_expired_button(order)
    if(order.has_expired_items?)
      '<span class="label label-danger">EXPIRED</span>'.html_safe
    elsif(order.line_items.present?)
      link_to "Checkout", checkout_order_path(order), class: "btn btn-primary",:data => {behaviour: "checkout" }
    end
  end

  def order_status_label(order)
    if order.pending?
      label_type = "warning"
    elsif order.paid?
      label_type = "primary"
    elsif order.cancelled?
      label_type = "danger"
    else
      label_type = "success"
    end
    "<span class='label label-#{label_type}'>#{order.status}</span>".html_safe
  end
end
