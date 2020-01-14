require 'rails_helper'

RSpec.describe 'coupons index page' do
  describe 'as a logged in merchant admin or merchant employee' do
    it "I can view all my coupons and for each coupon I can see:
    - the coupon's name
    - the coupon's unique code
    - the coupon's % off value" do

      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_admin = bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)

      coupon_1 = bike_shop.coupons.create!(name: "Ten Percent Off", code: "NEWYEAR10", percentage_off: 10)
      coupon_2 = bike_shop.coupons.create!(name: "Fifteen Percent Off", code: "FEBRUARY15", percentage_off: 15)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit '/merchant/coupons'

      within "#coupon-#{coupon_1.id}" do
        expect(page).to have_link(coupon_1.name)
        expect(page).to have_content("Coupon Code: #{coupon_1.code}")
        expect(page).to have_content("Percentage Off: #{coupon_1.percentage_off}")
      end

      within "#coupon-#{coupon_2.id}" do
        expect(page).to have_content("Coupon Code: #{coupon_2.code}")
        expect(page).to have_content("Percentage Off: #{coupon_2.percentage_off}")
        click_link(coupon_2.name)
      end

      expect(current_path).to eq("/merchant/coupons/#{coupon_2.id}")
    end
  end
end
