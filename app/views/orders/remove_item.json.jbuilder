if @removal_success
  json.total number_to_currency @order.calculate_total, unit: "Rs"
end
