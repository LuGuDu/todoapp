class Project
  include Mongoid::Document
  #field :id, type: Integer
  field :title, type: String
  field :description, type: String

  has_many :task, dependent: :destroy
end
