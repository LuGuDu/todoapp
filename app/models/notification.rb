class Notification 
    include Mongoid::Document

    field :origin_user_id, type: String
    field :dest_user_id, type: String
    field :message, type: String
    field :state, type: String

    belongs_to :project

end
