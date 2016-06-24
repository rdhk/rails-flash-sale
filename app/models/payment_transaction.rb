# == Schema Information
#
# Table name: payment_transactions
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  order_id           :integer          not null
#  charge_id          :string(255)      not null
#  stripe_token       :string(255)
#  amount             :decimal(10, )    not null
#  currency           :string(255)      not null
#  stripe_customer_id :string(255)
#  description        :string(255)      not null
#  stripe_email       :string(255)
#  stripe_token_type  :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  card_number_last4  :integer
#  card_name          :string(255)
#  expiry_month       :integer
#  expiry_year        :integer
#  refund_id          :string(255)
#
# Indexes
#
#  index_payment_transactions_on_order_id  (order_id)
#  index_payment_transactions_on_user_id   (user_id)
#

#FIXME_AB:  not needed for now
class PaymentTransaction < ActiveRecord::Base

  belongs_to :user
  belongs_to :order
  scope :charged, -> { where(refund_id: nil) }
  scope :refunded, -> { where.not(refund_id: nil) }

  def amount_to_rs
    amount / 100
  end
end
