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
  has_one :payment_transaction

  enum status: [:pending, :processing, :paid]
  scope :pending, -> { where(status: "pending") }
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
    #FIXME_AB: we'll have a callback when order is being marked paid, to increase sold qty. deal.increase_sold_qty_by(6)
  end

  def has_expired_items? #test
    deals.each do |deal|
      if(deal.expired?)
        return true
      end
    end
    false
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

    #FIXME_AB: user.can_buy_deal?(deal) + soldout + live
    # if(exists_in_current_order?(deal) || exists_in_prev_orders?(deal))
    #   return false
    # else       #make new line item
      line_items.build(deal_id: deal.id)
      save
  end

  def total_amount
    deals.sum(:discounted_price)
  end

  #FIXME_AB: no need of this function, you can directly use deals.include?(deal) - done
  # def exists_in_current_order?(deal)
  #   deals.include?(deal)
  # end

  def exists_in_prev_orders?(deal)
    #FIXME_AB: how are you ensuring that it won't check in user's pending order. You have user has_many deals through orders, which may includes current order also.
    #
    user.paid_deals.include?(deal)
  end


end
