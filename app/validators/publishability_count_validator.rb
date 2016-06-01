class PublishabilityCountValidator < ActiveModel::Validator

  def validate(record)
    # FIXME_AB: same
    if(record.publishable_deals_on(record.publish_date) >= MAX_DEALS_PER_DAY)
      record.errors[:base] << "Cant have more than " + MAX_DEALS_PER_DAY.to_s +  " publishable deals in a day"
    end
  end

end
