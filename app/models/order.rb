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

  enum status: [:pending, :processing, :paid]
  scope :pending, -> { where(status: "pending") }


  def clear_expired_deals
    current_day = Date.today
    #FIXME_AB: eager load deals
    line_items.each do |li|
      if(li.deal.expired?)
        line_items.delete(li)
      end
    end
  end

  def remove_item(line_item)
    line_items.delete(line_item)
  end

  def add_item(deal)
    #FIXME_AB: user.can_buy_deal?(deal)
    if(exists_in_current_order?(deal) || exists_in_prev_orders?(deal))
      return false
    else       #make new line item
      line_items.build(deal_id: deal.id)
      save
    end
  end

  #FIXME_AB: rename this to total_amount
  def calculate_total
    #FIXME_AB: use sum
    deals.pluck(:discounted_price).inject(0){|sum,x| sum + x }
  end

  #FIXME_AB: no need of this function, you can directly use deals.include?(deal)
  def exists_in_current_order?(deal)
    deals.include?(deal)
  end

  def exists_in_prev_orders?(deal)
    #FIXME_AB: how are you ensuring that it won't check in user's pending order. You have user has_many deals through orders, which may includes current order also. 
    #
    user.deals.include?(deal)
  end
end
