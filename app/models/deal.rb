# == Schema Information
#
# Table name: deals
#
#  id               :integer          not null, primary key
#  title            :string(255)      not null
#  description      :text(65535)
#  price            :integer
#  discounted_price :integer
#  quantity         :integer
#  publish_date     :date
#  publishable      :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  creator_id       :integer
#  publisher_id     :integer
#  live             :boolean          default(FALSE)
#  quantity_sold    :integer          default(0)
#  lock_version     :integer          default(0)
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
  validates_with PublishTimeValidator, unless: lambda { |d| d.resetting_live? || d.resetting_quantities?}
  validates_with DiscountedPriceValidator

  with_options if: :publishable? do |deal|
    deal.validates :title, :description, :price, :discounted_price, :quantity, :publish_date, presence: true
    deal.validates_with PublishabilityQtyValidator, ImagesCountValidator
  end

  validates_with DailyPublishabilityCountValidator , if: "publishable? && changes[:quantity_sold].nil?"
  validates :quantity_sold, numericality: {less_than_or_equal_to: ->(deal){ deal.quantity} }, if: "changes[:quantity_sold]"

  belongs_to :publisher, -> { where admin: true }, class_name: "User", foreign_key: "publisher_id"
  belongs_to :creator, -> { where admin: true }, class_name: "User", foreign_key: "creator_id"
  has_many :images, dependent: :destroy
  has_many :line_items

  accepts_nested_attributes_for :images, :allow_destroy => true

  scope :publishable, -> { where(publishable: true) }
  scope :past_publishable, -> { publishable.where("publish_date < ?", Date.today).where(live: false)}
  scope :live, -> { where(live: true) }
  scope :recent_past_deals, -> (lim = 2) { past_publishable.order(publish_date: :desc).limit(lim) }

  before_update :can_be_edited?
  before_destroy :can_be_destroyed?

  def potential
    discounted_price * quantity
  end

  def revenue
    line_items.sum(:discounted_price)
  end

  def loyalty_discount_price(rate)
    discounted_price - (price * rate / 100)
  end

  def increase_sold_qty_by(qty = 1)
    self.quantity_sold += qty
    save
  end

  def decrease_sold_qty_by(qty = 1)
    self.quantity_sold -= qty
    save
  end

  def resetting_quantities?
    (changes.length == 1) && changes[:quantity_sold]
  end

  def resetting_live?
    (changes.length == 1) && changes[:live]
  end

  def sold_out?
    #FIXME_AB: check admin end working fine, as we have made several changes in deal model
    #FIXME_AB: rake task should be working fine- test it
    (quantity - quantity_sold) <= 0
  end

  def expired?
    live.blank? && publishable && publish_date < Date.today
  end

  def self.reset_live_deals
    if(CONSTANTS["daily_publish_time"].hours.ago > Time.current.beginning_of_day)
      transaction do
        unpublish_old_deals!
        publish_current_deals!
      end
    end
  end

  def self.unpublish_old_deals!(previous_day = 1.day.ago)
    self.live.where(publish_date: previous_day).each do |deal|
      deal.live = false
      deal.save!
    end
  end

  def self.publish_current_deals!(current_day = Time.current.to_date)
    Deal.publishable.where(publish_date: current_day).each do |deal|
      deal.live = true
      deal.save!
    end
  end

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
