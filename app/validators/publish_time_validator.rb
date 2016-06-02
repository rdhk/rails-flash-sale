class PublishTimeValidator < ActiveModel::Validator

  def validate(record)
    if record.invalid_publish_time?
      record.errors[:publish_date] << "should be atleast " + MIN_TIME_TO_PUBLISH.to_s + " hours from now."
    end
  end

end
