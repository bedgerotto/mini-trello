class Task < ActiveRecord::Base
    belongs_to :history
    # Validating fields
    validates :description, presence: true
end
