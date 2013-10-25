class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.date :due_date
      t.timestamp :completed_at
      t.references :team, index: true

      t.timestamps
    end
  end
end
