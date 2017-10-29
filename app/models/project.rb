class Project < ActiveRecord::Base
    has_many :histories, dependent: :destroy
    belongs_to :manager, class_name: 'Person'
    # Validating fields
    validates :name, presence: true
end
