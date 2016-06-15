class AddLockVersionToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :lock_version, :integer, default: 0
  end
end
