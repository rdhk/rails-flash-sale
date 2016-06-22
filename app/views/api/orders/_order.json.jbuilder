json.extract! order, :id, :placed_at
json.total_amount order.total_amount
json.status order.status

json.items order.line_items do |li|
  json.name li.deal.title
  json.price li.discounted_price
end

json.address do
  json.id order.address.id
  json.house_no order.address.house_no
  json.street order.address.street
  json.city order.address.city
  json.pincode order.address.pincode
end

json.payment_transaction do
  json.charge_transaction do
    json.amount order.payment_transactions.charged.first.amount
    json.card_number_last4 order.payment_transactions.charged.first.card_number_last4
    json.expiry_date "#{order.payment_transactions.charged.first.expiry_month}/#{order.payment_transactions.charged.first.expiry_year}"
    json.created_at order.payment_transactions.charged.first.created_at
  end
 if order.cancelled?
  json.refund_transaction do
    json.amount order.payment_transactions.refunded.first.amount
    json.created_at order.payment_transactions.refunded.first.created_at
  end
 end
end
