class AddDiscountedPriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :discounted_price, :integer
  end
end
