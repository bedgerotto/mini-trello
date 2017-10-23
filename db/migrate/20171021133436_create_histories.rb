class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :name
      t.integer :requester_id
      t.string :status
      t.integer :owner_id
      t.text :description
      t.datetime :started_at
      t.datetime :finished_at
      t.datetime :deadline
      t.integer :points
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
