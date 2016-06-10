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
  #FIXME_AB: dependent? - done
  has_many :line_items, dependent: :destroy
  has_many :deals, through: :line_items

  enum status: [:pending, :processing, :paid]
  scope :pending, -> { where(status: "pending") }


  def clear_expired_deals
    current_day = Date.today
    line_items.each do |li|
      #FIXME_AB: need to change deal.expired?
      if(li.deal.expired?)
        line_items.delete(li)
      end
    end
  end


  def remove_item(line_item)
    line_items.delete(line_item)
  end

  def add_item(deal)
    #FIXME_AB: can_add_item?(deal)
    if(exists_in_current_order?(deal) || exists_in_prev_orders?(deal))
      return false
    else       #make new line item
      line_items.build(deal_id: deal.id)
      save
    end
  end

  def calculate_total
    #FIXME_AB: use sum
    deals.pluck(:discounted_price).inject(0){|sum,x| sum + x }
  end

  def exists_in_current_order?(deal)
    deals.include?(deal)
  end

  def exists_in_prev_orders?(deal)
    user.deals.include?(deal)
  end
end
