class User 
    include Mongoid::Document
    include ActiveModel::SecurePassword
    has_secure_password

    field :username, type: String
    field :email, type: String
    field :password_digest, type: String
    field :role, type: String

    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
end
