# == Schema Information
#
# Table name: line_items
#
#  id               :integer          not null, primary key
#  order_id         :integer
#  deal_id          :integer
#  discounted_price :integer
#
# Indexes
#
#  index_line_items_on_deal_id   (deal_id)
#  index_line_items_on_order_id  (order_id)
#

class LineItem < ActiveRecord::Base

  validates :order, :deal, :discounted_price, presence: true

  belongs_to :order
  belongs_to :deal

end
