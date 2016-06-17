class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :house_no
      t.string :street
      t.string :city
      t.integer :pincode
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
