class Project
  include Mongoid::Document
  
  field :title, type: String
  field :description, type: String

  has_many :task, dependent: :destroy
  belongs_to :user, optional: true
end
