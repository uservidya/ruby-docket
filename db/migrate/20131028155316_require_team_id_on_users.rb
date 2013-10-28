class RequireTeamIdOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :team_id, :integer , null: false
  end
end
