module OrdersHelper
  def pay_now_button(order)
    if(order.line_items.present?)
      link_to "Checkout", checkout_order_path(order), class: "btn btn-primary",:data => {behaviour: "checkout" }
    end
  end
end
