if @publish_success
  json.status "success"
  json.publisher @deal.publisher.email
else
  json.status "error"
  json.errors @deal.errors.full_messages
end
