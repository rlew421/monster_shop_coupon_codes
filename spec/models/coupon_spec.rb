require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_uniqueness_of :name}
    it {should validate_presence_of :code}
    it {should validate_uniqueness_of :code}
    it {should validate_presence_of :percentage_off}
    it {should validate_numericality_of(:percentage_off).is_less_than_or_equal_to(100)}
  end

  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :orders}
  end
end
