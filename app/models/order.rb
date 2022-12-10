class Order < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements
  # validates :total, numericality: { greater_than_or_equal_to: 0 }, presence: true
  before_validation :set_total!

  def set_total!
    # self.total = products.map(&:price).sum
    self.total = products.sum(&:price)
  end
end
