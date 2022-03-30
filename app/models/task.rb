class Task
  include Mongoid::Document
  
  field :title, type: String
  field :description, type: String
  field :priority, type: Integer
  field :dateCreation, type: DateTime
  field :dateDeadLine, type: DateTime
  field :done, type: Boolean
  
  belongs_to :project, optional: true
  belongs_to :user, optional: true
end
