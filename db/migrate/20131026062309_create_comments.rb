class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.timestamp :deleted_at
      t.references :task, null: false, index: true
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end
