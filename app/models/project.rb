class Project
  include Mongoid::Document
  
  field :title, type: String
  field :description, type: String
  field :revoke, type: Boolean

  has_many :task, dependent: :destroy
  has_many :notifications, dependent: :destroy
  belongs_to :user, optional: true
end
