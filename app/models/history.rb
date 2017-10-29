class History < ActiveRecord::Base
    has_many :tasks, dependent: :destroy
    belongs_to :project
    belongs_to :requester, :class_name => "Person", :foreign_key => "requester_id"
    belongs_to :owner, :class_name => "Person", :foreign_key => "owner_id"

    # Validating fields
    validates :name, :status, :requester_id, presence: true

    # Finds histories and returns a hash separated by status
    def self.find_histories_by_status(project_id)
        # Sets empty hash
        histories = {"started": [], "pending": [], "delivered": []}

        if project_id

            # Finds the histories by status
            pending = History.where(status: "pending", project_id: project_id).to_json( :include => [:tasks])
            started = History.where(status: "started", project_id: project_id).to_json( :include => [:tasks])
            delivered = History.where(status: ["delivered", "accepted"], project_id: project_id).to_json( :include => [:tasks])

            # Creates hash with each state
            histories = {"started": started, "pending": pending, "delivered": delivered}
        end
        histories
    end
end