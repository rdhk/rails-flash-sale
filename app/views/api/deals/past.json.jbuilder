json.deals do
  json.array! @deals, partial: 'api/deals/deal', as: :deal
end
