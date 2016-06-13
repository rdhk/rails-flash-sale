# == Schema Information
#
# Table name: line_items
#
#  id       :integer          not null, primary key
#  order_id :integer
#  deal_id  :integer
#
# Indexes
#
#  index_line_items_on_deal_id   (deal_id)
#  index_line_items_on_order_id  (order_id)
#

class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :deal
#FIXME_AB: lineitem would have many more attributes.
end
