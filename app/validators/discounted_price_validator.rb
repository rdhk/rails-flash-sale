class DiscountedPriceValidator < ActiveModel::Validator

  def validate(record)

    if(record.invalid_discounted_price?)
      record.errors[:discounted_price] << "can't be greater than the price."
    end
  end

end
