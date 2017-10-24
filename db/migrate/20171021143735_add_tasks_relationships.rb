class AddTasksRelationships < ActiveRecord::Migration[5.1]
  def change
    # Field history_id references History.id
    add_foreign_key :tasks, :histories
  end
end
