require 'rails_helper'

RSpec.describe "as an admin" do
  it "when I visit the merchant index page and click on a merchant's name, I navigate to that merchant's dashboard and see
  - the information of the merchant store
  - any orders that contain items from that merchant with info for those orders
  - a link to view that merchant's items" do

    admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    shifter = bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/merchants'

    within "#merchant-#{bike_shop.id}" do
      click_link "#{bike_shop.name}"
    end

    expect(current_path).to eq("/admin/merchants/#{bike_shop.id}")

    expect(page).to have_content(bike_shop.name)
    expect(page).to have_content(bike_shop.address)
    expect(page).to have_content(bike_shop.city)
    expect(page).to have_content(bike_shop.state)
    expect(page).to have_content(bike_shop.zip)

    click_link "View #{bike_shop.name}'s Items"
    expect(current_path).to eq("/admin/merchants/#{bike_shop.id}/items")
  end
end
