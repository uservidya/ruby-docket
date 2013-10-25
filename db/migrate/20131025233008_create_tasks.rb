class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :body
      t.float :estimate
      t.timestamp :completed_at
      t.references :project, null: false, index: true
      t.references :reporter, null: false, index: true
      t.references :owner, index: true

      t.timestamps
    end
  end
end
