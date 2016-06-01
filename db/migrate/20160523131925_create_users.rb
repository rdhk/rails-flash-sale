class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null:false
      t.string :email, null:false
      t.string :password_digest, null:false
      t.boolean :admin, default: false
      t.string :verification_token
      t.timestamp :verification_token_expires_at
      t.timestamp :verified_at
      t.string :password_change_token
      t.timestamp :password_token_expires_at
      t.string :remember_me_token

      t.timestamps null: false
    end
  end
end
