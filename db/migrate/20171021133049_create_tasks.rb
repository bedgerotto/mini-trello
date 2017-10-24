class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :description
      t.integer :history_id
      t.boolean :done

      t.timestamps null: false
    end
  end
end
