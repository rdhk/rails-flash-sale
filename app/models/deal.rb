class Deal < ActiveRecord::Base

  scope :publishable, -> {where(publishable: true)}

  validates :title, presence: true

  validates :price, presence:true, if: :discounted_price?
  validates :price, numericality: { greater_than: 0 }, allow_blank: true
  validates :discounted_price, presence:true, if: :price?
  validates :discounted_price, numericality: { greater_than: 0 }, allow_blank: true
  #FIXME_AB: make us of with_option - done
  validates_with PublishTimeValidator, DiscountedPriceValidator

  with_options if: :publishable? do |deal|
    deal.validates :title, :description, :price, :discounted_price, :quantity, :publish_date, presence: true
    deal.validates_with PublishabilityQtyValidator, PublishabilityCountValidator
  end


  before_update :can_be_edited?

  def publish
    self.publishable = true
    save
  end

  def unpublish
    self.publishable = false
    save
  end

  #FIXME_AB: publish_time
  def publish_time
    if(publish_date)
      publish_date + DAILY_PUBLISH_TIME.hours
    end
  end

  def invalid_discounted_price?
    discounted_price && price && (discounted_price > price)
  end

  #FIXME_AB: deal.can_be_edited?
  def can_be_edited?
    #FIXME_AB: if changes.include?(:publish_date) && publish_date_was ...
    if changes.include?(:publish_date) && ((publish_date_was + DAILY_PUBLISH_TIME.hours - Time.current) < MINIMUM_TIME_BEFORE_DEAL_CHANGE.hours)
      errors[:publish_date] << "can't be changed before #{MINIMUM_TIME_BEFORE_DEAL_CHANGE} hours of old date."
      false
    end
  end

  #FIXME_AB: publishable_deals_on(date = Date.current)
  def publishable_deals_on(date = Date.current)
    Deal.publishable.where(publish_date: date).count
  end

end
