if @unpublish_success
  json.status "success"
else
  json.status "error"
  json.errors @deal.errors.full_messages
end
