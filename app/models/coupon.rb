class Coupon < ApplicationRecord
  validates :name, :code, uniqueness: true, presence: true
  validates_presence_of :percentage_off
  validates_numericality_of :percentage_off, less_than_or_equal_to: 100
  belongs_to :merchant
  has_many :orders
end
