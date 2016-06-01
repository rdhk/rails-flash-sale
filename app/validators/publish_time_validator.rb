class PublishTimeValidator < ActiveModel::Validator

  def validate(record)
    publish_time = record.publish_time

    #FIXME_AB: don't hardcode 24 hours, move to yml
    if publish_time && ((publish_time - Time.current) < MINIMUM_TIME_BEFORE_DEAL_CHANGE.hours)
      record.errors[:publish_date] << "should be atleast " + MINIMUM_TIME_BEFORE_DEAL_CHANGE.to_s + " hours from now."
    end

  end

end
