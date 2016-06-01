class DropNullabilityInDealsTable < ActiveRecord::Migration
  def up
    change_column :deals, :price, :integer, :null => true
    change_column :deals, :discounted_price, :integer, :null => true
    change_column :deals, :quantity, :integer, :null => true
    # change_column :deals, :publish_date, :timestamp, :null => true
    change_column_null(:deals, :publish_date, true)
  end

  def down
    change_column :deals, :price, :integer, :null => false
    change_column :deals, :discounted_price, :integer, :null => false
    change_column :deals, :quantity, :integer, :null => false
  end
end
