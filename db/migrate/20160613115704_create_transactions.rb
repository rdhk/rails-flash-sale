class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :payment_transactions do |t|

     t.references :user, index: true, null: false
     t.references :order, index: true, null:false
     t.string :charge_id, null: false
     t.string :stripe_token, null: false
     t.decimal :amount, null: false
     t.string :currency, null: false
     t.string :stripe_customer_id, null: false
     t.string :description, null: false
     t.string :stripe_email, null: false
     t.string :stripe_token_type, null: false
     t.timestamps null: false
    end
  end
end
