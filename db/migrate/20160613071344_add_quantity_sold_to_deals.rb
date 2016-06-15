class AddQuantitySoldToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :quantity_sold, :integer, default: 0
  end
end
