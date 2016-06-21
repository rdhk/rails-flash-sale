if @deal.nil?
  json.status "error"
elsif @deal.sold_out? && @deal.expired?
  json.status "sold_and_expired"
elsif @deal.sold_out?
  json.status "sold_out"
elsif @deal.expired?
  json.status "expired"
else
  json.status "normal"
end
