# == Schema Information
#
# Table name: deals
#
#  id               :integer          not null, primary key
#  title            :string(255)      not null
#  description      :string(255)
#  price            :integer
#  discounted_price :integer
#  quantity         :integer
#  publish_date     :datetime
#  publishable      :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  creator_id       :integer
#  publisher_id     :integer
#
# Indexes
#
#  index_deals_on_creator_id    (creator_id)
#  index_deals_on_publisher_id  (publisher_id)
#

class Deal < ActiveRecord::Base


  validates :title, presence: true

  validates :price, presence:true, if: :discounted_price?
  validates :price, numericality: { greater_than: 0 }, allow_blank: true
  validates :discounted_price, presence:true, if: :price?
  validates :discounted_price, numericality: { greater_than: 0 }, allow_blank: true
  validates_with PublishTimeValidator, DiscountedPriceValidator

  with_options if: :publishable? do |deal|
    deal.validates :title, :description, :price, :discounted_price, :quantity, :publish_date, presence: true
    deal.validates_with PublishabilityQtyValidator, DailyPublishabilityCountValidator, ImagesCountValidator
  end

  #FIXME_AB: PublishabilityCountValidator to DailyPublishabilityCountValidator

  belongs_to :publisher, -> { where admin: true }, class_name: "User", foreign_key: "publisher_id"
  belongs_to :creator, -> { where admin: true }, class_name: "User", foreign_key: "creator_id"
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true

  scope :publishable, -> { where(publishable: true) }

  before_update :can_be_edited?
  before_destroy :can_be_destroyed?


  def can_be_destroyed?
    if(invalid_publish_time?)
      errors[:base] << title + " can't be destoyed " + MIN_TIME_TO_PUBLISH.to_s + " hours prior to publish date and later."
      false
    end
  end

  def set_creator(current_user)
    self.creator = current_user
  end

  def set_publisher(current_user)
    if self.publishable
      self.publisher = current_user
    end
  end

  def publish(current_user)
    self.publishable = true
    self.publisher = current_user
    save
  end

  def unpublish
    self.publishable = false
    self.publisher = nil
    save
  end

  def publish_time
    if(publish_date)
      publish_date + DAILY_PUBLISH_TIME.hours
    end
  end

  def invalid_publish_time?
    publish_time && ((publish_time) < MIN_TIME_TO_PUBLISH.hours.from_now)
  end

  def invalid_discounted_price?
    discounted_price && price && (discounted_price > price)
  end

  def can_be_edited?
    if changes.include?(:publish_date) && publish_date_was && ((publish_date_was + DAILY_PUBLISH_TIME.hours) < MIN_TIME_TO_PUBLISH.hours.from_now)
      errors[:publish_date] << "can't be changed before #{MIN_TIME_TO_PUBLISH} hours of old date."
      false
    end
  end

  def publishable_deals_on(date = Date.current)
    Deal.publishable.where(publish_date: date).count
  end

end
