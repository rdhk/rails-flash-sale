class AddAddressPlacedAtToOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.references :address, index: true
      t.timestamp :placed_at
    end
  end
end
