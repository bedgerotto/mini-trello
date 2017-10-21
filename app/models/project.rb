class Project < ActiveRecord::Base
    has_many histories, dependent: destroy
    belongs_to :person
end
