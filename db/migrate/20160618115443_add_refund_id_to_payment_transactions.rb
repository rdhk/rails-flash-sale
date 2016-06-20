class AddRefundIdToPaymentTransactions < ActiveRecord::Migration
  def change
    change_table :payment_transactions do |t|
      t.string :refund_id
    end
  end
end
