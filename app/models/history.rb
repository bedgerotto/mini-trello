class History < ActiveRecord::Base
    has_many :tasks, dependent: :destroy
    belongs_to :project
    belongs_to :requester, :class_name => "Person", :foreign_key => "requester_id"
    belongs_to :owner, :class_name => "Person", :foreign_key => "owner_id"
end
