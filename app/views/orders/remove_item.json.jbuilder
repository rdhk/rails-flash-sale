if @removal_success
  json.total number_to_currency @order.total_amount, unit: "₹"
end
