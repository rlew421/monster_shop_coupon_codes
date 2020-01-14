require 'rails_helper'

RSpec.describe 'edit merchant coupons' do
  describe "when I visit the merchant's coupons index page as a merchant admin or merchant employee" do
    it "I can click a link that takes me to a form to edit a coupon" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_admin = bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      coupon_1 = bike_shop.coupons.create!(name: "Ten Percent Off", code: "NEWYEAR10", percentage_off: 10)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit '/merchant/coupons'

      within "#coupon-#{coupon_1.id}" do
        click_link "Edit #{coupon_1.name}"
      end

      expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}/edit")

      expect(find_field(:name).value).to eq("Ten Percent Off")
      expect(find_field(:code).value).to eq("NEWYEAR10")
      expect(find_field(:percentage_off).value).to eq("10.0")

      fill_in :name, with: "Roaring Twenties"
      fill_in :code, with: "NEWYEAR2020"
      fill_in :percentage_off, with: 20
      click_button "Update Coupon"

      expect(current_path).to eq('/merchant/coupons')

      within "#coupon-#{coupon_1.id}" do
        expect(page).to have_link("Roaring Twenties")
        expect(page).to have_content("Coupon Code: NEWYEAR2020")
        expect(page).to have_content("Percentage Off: 20.0")
        expect(page).to_not have_content("Ten Percent Off")
        expect(page).to_not have_content("Coupon Code: NEWYEAR10")
        expect(page).to_not have_content("Percentage Off: 10.0")
        click_link("Edit Roaring Twenties")
      end

      expect(find_field(:name).value).to eq("Roaring Twenties")
      expect(find_field(:code).value).to eq("NEWYEAR2020")
      expect(find_field(:percentage_off).value).to eq("20.0")

      fill_in :name, with: "Twenty Off"
      click_button "Update Coupon"

      within "#coupon-#{coupon_1.id}" do
        expect(page).to have_content("Twenty Off")
        expect(page).to_not have_content("Roaring Twenties")
        expect(page).to have_content("Coupon Code: NEWYEAR2020")
        expect(page).to have_content("Percentage Off: 20.0")
      end
    end
  end
end
