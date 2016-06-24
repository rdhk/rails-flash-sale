json.extract! deal, :id, :title, :description, :price, :discounted_price, :quantity, :quantity_sold, :publish_date
if deal.creator
  json.creator deal.creator.email
end
if deal.publisher
  json.publisher deal.publisher.email
end
