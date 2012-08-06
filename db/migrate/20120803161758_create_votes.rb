class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :answer_id

      t.timestamps
    end

    add_index :votes, :answer_id
    add_index :votes, :user_id
  end
end
