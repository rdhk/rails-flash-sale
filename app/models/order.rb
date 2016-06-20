# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  address_id :integer
#  placed_at  :datetime
#
# Indexes
#
#  index_orders_on_address_id  (address_id)
#  index_orders_on_user_id     (user_id)
#

class Order < ActiveRecord::Base

  belongs_to :user
  belongs_to :address
  has_many :line_items, dependent: :destroy
  has_many :deals, through: :line_items
  #FIXME_AB: we would need to convert it in has_many when admin cancle and refunds
  has_many :payment_transactions, dependent: :restrict_with_error

  enum status: [:pending, :delivered, :paid, :cancelled]

  scope :pending, -> { where(status: Order.statuses[:pending]) }
  scope :paid, -> { where(status: Order.statuses[:paid]) }
  scope :placed, -> {where.not(placed_at: nil)}
  scope :last_placed_order, -> {placed.order(placed_at: :desc).limit(1)}

  validates_with OrderPurchasabilityValidator, if: "pending? || marking_paid?"
  #FIXME_AB: validate that address shoudl be associated with order when marking an order as paid - done
  validates :address, presence: true, if: :marking_paid?

  before_save :increase_sold_quantities , if: :marking_paid?
  #FIXME_AB: ensure pending to paid - done
  after_commit :send_order_confirmation_email, if: "previous_changes[:status] && paid? && (previous_changes[:status][0]=='pending')"

  def marking_paid?
    changes[:status] && paid?
  end

  def send_order_confirmation_email
    UserNotifier.order_confirmation_mail(self).deliver
  end

  def total_amount_paise
    total_amount * 100
  end

  def increase_sold_quantities
    deals.each do |deal|
      deal.increase_sold_qty_by(1)
    end
    # debugger
  end

  def mark_paid(transaction_params)
    self.status = 'paid'
    self.placed_at = Time.current
    payment_transactions.build(transaction_params)
    save
  end

  def has_expired_items? #test
    deals.any? { |deal| deal.expired? }
  end

  #FIXME_AB: test it
  def clear_expired_deals
    line_items.includes(:deal).each do |li|
      if(li.deal.expired?)
        line_items.delete(li)
      end
    end
  end

  def remove_item(line_item)
    line_items.delete(line_item)
  end

  def add_item(deal)
    price = deal.loyalty_discount_price(user.loyalty_discount_rate)
    line_items.build(deal_id: deal.id, discounted_price: price)
    save
  end

  def total_amount
    line_items.sum(:discounted_price)
  end

  def exists_in_prev_orders?(deal)
    user.purchased_deals.include?(deal)
  end


end
