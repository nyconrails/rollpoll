class RemoveExtraUser < ActiveRecord::Migration
  def change
    remove_column :answers, :user_id
  end
end
