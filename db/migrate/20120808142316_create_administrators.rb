class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :name
      t.string :username
      t.string :password_digest

      t.timestamps
    end
    add_index :administrators, :username, :unique => true
  end
end
