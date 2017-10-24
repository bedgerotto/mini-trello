class AddProjectRelationships < ActiveRecord::Migration[5.1]
  def change
    # Field manager_id references Person.id
    add_foreign_key :projects, :people, column: "manager_id"
  end
end
