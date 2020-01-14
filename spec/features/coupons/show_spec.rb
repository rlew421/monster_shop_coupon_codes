require 'rails_helper'

RSpec.describe 'coupon show page' do
  describe 'as a logged in merchant admin or merchant employee' do
    it "I can see an individual coupon's information including:
    - name
    - unique code
    - percentage off
    - merchant it belongs to" do

      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_admin = bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      coupon_1 = bike_shop.coupons.create!(name: "Ten Percent Off", code: "NEWYEAR10", percentage_off: 10)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit "/merchant/coupons/#{coupon_1.id}"
      
      expect(page).to have_content(coupon_1.name)
      expect(page).to have_content("Coupon Code: #{coupon_1.code}")
      expect(page).to have_content("Percentage Off: #{coupon_1.percentage_off}")
      expect(page).to have_content(bike_shop.name)
    end
  end
end
