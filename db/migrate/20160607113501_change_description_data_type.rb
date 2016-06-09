class ChangeDescriptionDataType < ActiveRecord::Migration
  def change
    change_column :deals, :description, :text
  end
end
