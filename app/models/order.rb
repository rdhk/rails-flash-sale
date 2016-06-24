# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  status       :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  address_id   :integer
#  placed_at    :datetime
#  delivered_at :datetime
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
  has_many :payment_transactions, dependent: :restrict_with_error

  enum status: {pending: 0, paid: 1, delivered: 2, cancelled: 3}

  scope :pending, -> { where(status: Order.statuses[:pending]) }
  scope :paid, -> { where(status: Order.statuses[:paid]) }
  scope :cancelled, -> { where(status: Order.statuses[:cancelled]) }
  scope :delivered, -> { where(status: Order.statuses[:delivered]) }
  scope :placed, -> {where.not(placed_at: nil)}
  scope :last_placed_order, -> {placed.order(placed_at: :desc).limit(1)}
  scope :search_by_email, ->(q) {joins(:user).where("users.email LIKE ?", "%#{q}%")}

  validates_with OrderPurchasabilityValidator, if: "pending? || marking_paid?"
  validates :address, presence: true, if: :marking_paid?

  before_save :increase_sold_quantities , if: :marking_paid?
  before_save :decrease_sold_quantities, if: :marking_cancelled_before_save?
  validates :status, inclusion: { in: %w(cancelled delivered)}, if: "changes[:status] && changes[:status][0]=='paid'"
  #ensure that order is paid initially before its marked cancelled or delivered
  after_commit :send_order_confirmation_email, if: "previous_changes[:status] && paid? && (previous_changes[:status][0]=='pending')"
  after_commit :send_delivery_mail, if: :marking_delivered?
  after_commit :send_cancellation_mail, if: :marking_cancelled?

  def decrease_sold_quantities
    deals.each do |deal|
      deal.decrease_sold_qty_by(1)
    end
    # debugger
  end

  def send_delivery_mail
    UserNotifier.order_delivery_mail(self).deliver
  end

  def send_cancellation_mail
    UserNotifier.order_cancellation_mail(self).deliver
  end

  def marking_delivered?
    previous_changes[:status] && delivered?
  end

  def marking_cancelled?
    previous_changes[:status] && cancelled?
  end

  def marking_cancelled_before_save?
    changes[:status] && cancelled?
  end

  def mark_delivered
    self.status = "delivered"
    self.delivered_at = Time.current
    save
  end

  def mark_cancelled
    self.status = "cancelled"
    generate_refund
    save
  end

  def placed?
    placed_at.present?
  end

  def get_refund_transaction_params(refund)
    {
      user_id: self.user_id,
      refund_id: refund.id,
      charge_id: refund.charge,
      amount: refund.amount,
      currency: refund.currency,
      description:"#{user.email} was refunded Rs #{total_amount} for order number #{id}",
    }
  end

  def generate_refund
    refund_object = Stripe::Refund.create(
      charge: payment_transactions.charged.first.charge_id
    )
    payment_transactions.build(get_refund_transaction_params(refund_object))
  end

  def ensure_valid_status
    ["cancelled", "delivered"].include?(self.status)
  end

  def set_address(address)
    self.address = address
    save
  end

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
