class Task
  include Mongoid::Document
  field :id, type: Integer
  field :title, type: String
  field :description, type: String
  field :priority, type: Integer
  
  belongs_to :project, optional: true
end
