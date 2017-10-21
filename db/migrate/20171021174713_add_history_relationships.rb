class AddHistoryRelationships < ActiveRecord::Migration
  def change
    # Field requester_id references Person.id
    add_foreign_key :histories, :people, column: "requester_id"
    # Field owner_id references Person.id
    add_foreign_key :histories, :people, column: "owner_id"
  end
end
