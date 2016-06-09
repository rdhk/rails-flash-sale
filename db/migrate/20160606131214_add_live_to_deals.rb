class AddLiveToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :live, :boolean, default: false
  end
end
