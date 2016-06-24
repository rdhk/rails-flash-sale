class AddEnabledToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :enabled, default: true
    end
  end
end
