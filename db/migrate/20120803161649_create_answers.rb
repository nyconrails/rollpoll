class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.integer :user_id
      t.string :answer

      t.integer :votes_count

      t.timestamps
    end

    add_index :answers, :question_id
    add_index :answers, :user_id
  end
end
