class PublishabilityQtyValidator < ActiveModel::Validator

  def validate(record)
    #FIXME_AB: don't hardcode 10
    if(record.quantity && record.quantity < MINIMUM_PUBLISHABILITY_QUANTITY)
      record.errors[:quantity] << ("must be atleast " + MINIMUM_PUBLISHABILITY_QUANTITY.to_s)
    end
  end

end
