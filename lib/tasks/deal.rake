namespace :deal do
  desc "publish new deals and unpublish old deals"
  task reset_published_deals: :environment do
    Deal.reset_live_deals
  end

end
