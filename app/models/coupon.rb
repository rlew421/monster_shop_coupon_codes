class Coupon < ApplicationRecord
  validates :name, :code, uniqueness: true, presence: true
  validates_presence_of :percentage_off
  belongs_to :merchant
  has_many :orders
end
