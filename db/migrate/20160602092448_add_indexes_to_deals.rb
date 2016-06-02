class AddIndexesToDeals < ActiveRecord::Migration
  def change
    change_table(:deals) do |t|
      t.index :creator_id
      t.index :publisher_id
    end
  end
end
