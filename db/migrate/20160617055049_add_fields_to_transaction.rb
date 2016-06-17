class AddFieldsToTransaction < ActiveRecord::Migration
  def change
    change_table :payment_transactions do |t|
      t.integer :card_number_last4
      t.string :card_name
      t.integer :expiry_month
      t.integer :expiry_year
    end
  end
end
