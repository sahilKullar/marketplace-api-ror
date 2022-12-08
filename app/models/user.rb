class User < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :email, uniqueness: true
  validates :email, format: { with: /@/ }
  validates :password_digest, presence: true
  has_secure_password
end
