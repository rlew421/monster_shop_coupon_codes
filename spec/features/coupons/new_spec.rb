require 'rails_helper'

RSpec.describe "create merchant coupons" do
  describe "when I visit the merchant coupons index page as a logged in merchant admin or merchant employee" do
    it "I see a link that takes me a form to create a new coupon for my store" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_admin = bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit '/merchant/coupons'

      click_link "Create New Coupon"

      expect(current_path).to eq('/merchant/coupons/new')

      fill_in :name, with: "Half Off"
      fill_in :code, with: "NIFTYFIFTY"
      fill_in :percentage_off, with: 50.0
      click_button "Create New Coupon"
      
      expect(current_path).to eq('/merchant/coupons')
      expect(page).to have_content("Half Off")
      expect(page).to have_content("Coupon Code: NIFTYFIFTY")
      expect(page).to have_content("Percentage Off: 50.0")
    end
  end
end
