class AddProjectToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :project_id, :integer
  end
end
