class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :title, null: false
      t.string :description
      t.integer :price, null: false
      t.integer :discounted_price
      t.integer :quantity, null: false
      t.timestamp :publish_date, null: false
      t.boolean :publishable, default: false

      t.timestamps null: false
    end
  end
end
