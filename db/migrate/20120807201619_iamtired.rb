class Iamtired < ActiveRecord::Migration
  def change
    rename_column :votes, :project_id, :question_id
  end
end
