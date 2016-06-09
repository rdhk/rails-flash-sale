class ChangeDateFormatInDeals < ActiveRecord::Migration
def up
    change_column :deals, :publish_date, :date
  end

  def down
    change_column :deals, :publish_date, :timestamp
  end
end
