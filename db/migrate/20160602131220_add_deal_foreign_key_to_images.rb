class AddDealForeignKeyToImages < ActiveRecord::Migration
  def change
    add_reference(:images, :deal)
  end
end
