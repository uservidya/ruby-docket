class RequireNameOnTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :name, :string , null: false
  end
end
