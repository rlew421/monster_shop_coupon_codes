require 'rails_helper'

RSpec.describe 'destroy a coupon' do
  describe "as a logged in merchant admin or merchant employee on the merchant's index page" do
    it "I see a link next to each coupon that allows me to delete that coupon" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_admin = bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      coupon_1 = bike_shop.coupons.create!(name: "Ten Percent Off", code: "NEWYEAR10", percentage_off: 10)
      coupon_2 = bike_shop.coupons.create!(name: "Fifteen Percent Off", code: "FEBRUARY15", percentage_off: 15)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit '/merchant/coupons'

      within "#coupon-#{coupon_1.id}" do
        expect(page).to have_link("Delete #{coupon_1.name}")
      end

      within "#coupon-#{coupon_2.id}" do
        click_link "Delete #{coupon_2.name}"
      end

      expect(current_path).to eq('/merchant/coupons')
      within "#coupon-#{coupon_1.id}" do
        expect(page).to have_link("Delete #{coupon_1.name}")
      end

      expect(page).to_not have_content(coupon_2.name)
    end
  end
end
