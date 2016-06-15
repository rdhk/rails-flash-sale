class OrderPurchasabilityValidator < ActiveModel::Validator

  def validate(record)
    record.line_items.each do |li|
      deal = li.deal
      if(deal.expired?)
        record.errors[:base] << "#{deal.title} has expired."
      elsif(deal.sold_out?)
        record.errors[:base] << "#{deal.title} has been sold out."
      elsif(record.exists_in_prev_orders?(deal))
        record.errors[:base] << "#{deal.title} has already been purchased by you."
      end
    end
  end

end
