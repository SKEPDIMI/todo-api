class User < ApplicationRecord
  has_secure_password
  has_many :todos, foreign_key: :created_by, dependent: :destroy

  validates_presence_of :email, :password_digest
end
