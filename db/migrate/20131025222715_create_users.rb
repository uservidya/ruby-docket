class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.references :team, index: true

      t.timestamps
    end
  end
end
