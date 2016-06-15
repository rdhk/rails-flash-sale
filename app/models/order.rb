# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#

class Order < ActiveRecord::Base

  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :deals, through: :line_items
  #FIXME_AB: order should not be destroyed if it has payment_transaction
  has_one :payment_transaction

  enum status: [:pending, :processing, :paid]

  scope :pending, -> { where(status: "pending") }

  #FIXME_AB: this need to be checked when order is pending or its being paid. not after that
  validates_with OrderPurchasabilityValidator, if: "pending? || changes[:status]"

  before_save :increase_sold_quantities , if: "changes[:status] && paid?"

  def increase_sold_quantities
    deals.each do |deal|
      deal.increase_sold_qty_by(1)
    end
    # debugger
  end

  def mark_paid
    self.status = 'paid'
    save
  end

  def has_expired_items? #test
    #FIXME_AB:  use any?
    deals.each do |deal|
      if(deal.expired?)
        return true
      end
    end
    false
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
    line_items.build(deal_id: deal.id)
    save
  end

  def total_amount
    deals.sum(:discounted_price)
  end

  def exists_in_prev_orders?(deal)
    user.paid_deals.include?(deal)
  end


end
