class AddHistoryRelationships < ActiveRecord::Migration[5.1]
  def change
    # Field requester_id references Person.id
    add_foreign_key :histories, :people, column: "requester_id"
    # Field owner_id references Person.id
    add_foreign_key :histories, :people, column: "owner_id"
    # Field project_id references Project.id
    add_foreign_key :histories, :projects, column: "project_id"
  end
end
