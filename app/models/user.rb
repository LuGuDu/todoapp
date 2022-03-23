class User 
    include Mongoid::Document
    field :username, type: String
    field :Email, type: String
    field :PassWord, type: String
end
