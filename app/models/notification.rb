class User 
    include Mongoid::Document

    field :origin_user_id, type: String
    field :dest_user_id, type: String
    field :message, type: String
    field :state, type: String

    has_one :project

end
