class RemoveNullConstraintFromStripeToken < ActiveRecord::Migration
  def self.up
    change_column :payment_transactions, :stripe_token, :string, :null => true
    change_column :payment_transactions, :stripe_customer_id, :string, :null => true
    change_column :payment_transactions, :stripe_email, :string, :null => true
    change_column :payment_transactions, :stripe_token_type, :string, :null => true
  end

  def self.down
    change_column :payment_transactions, :stripe_token, :string, :null => false
    change_column :payment_transactions, :stripe_customer_id, :string, :null => false
    change_column :payment_transactions, :stripe_email, :string, :null => false
    change_column :payment_transactions, :stripe_token_type, :string, :null => false
  end
end
