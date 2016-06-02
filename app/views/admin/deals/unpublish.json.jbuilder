if @unpublish_success
  json.status "success"
  json.publisher ""
else
  json.status "error"
  json.errors @deal.errors.full_messages
end
