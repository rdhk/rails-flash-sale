class AddIndexesToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.index :email
    end
  end
end
