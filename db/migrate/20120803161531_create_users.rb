class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :zip
      t.date :dob
      t.string :gender

      t.integer :questions_count
      t.integer :votes_count

      t.timestamps
    end

    add_index :users, :email, :unique => true
    add_index :users, [:email, :password_digest]
    add_index :users, :gender
  end
end
