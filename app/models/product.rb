class Product < ApplicationRecord
  belongs_to :user
  validates :title, presence: true # user_id presence is required by default
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
