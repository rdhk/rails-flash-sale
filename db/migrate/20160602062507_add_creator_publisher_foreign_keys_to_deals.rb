class AddCreatorPublisherForeignKeysToDeals < ActiveRecord::Migration
  def change
    change_table(:deals) do |t|
      t.column :creator_id, :integer, index: true
      t.column :publisher_id, :integer, index: true
    end
  end
end

