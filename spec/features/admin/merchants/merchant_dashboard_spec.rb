require 'rails_helper'

RSpec.describe "as an admin" do
  it "when I visit the merchant index page and click on a merchant's name, I navigate to that merchant's dashboard and see
  - the information of the merchant store
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

  it "I see any pending orders that contain items from that merchant with info for those orders" do
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    ski_shop = Merchant.create(name: "Ski Palace", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    skis = ski_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")

    order_1 = user.orders.create!(name: 'Bob', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    order_2 = user.orders.create!(name: 'Bob', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    order_3 = user.orders.create!(name: 'Bob', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    order_4 = user.orders.create!(name: 'Bob', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 1)

    item_order_1 = order_1.item_orders.create!(item: chain, price: chain.price, quantity: 1)
    item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 5)
    item_order_2 = order_2.item_orders.create!(item: tire, price: tire.price, quantity: 20)
    item_order_2 = order_2.item_orders.create!(item: skis, price: skis.price, quantity: 7)
    item_order_3 = order_3.item_orders.create!(item: skis, price: skis.price, quantity: 2)
    item_order_4 = order_4.item_orders.create!(item: chain, price: chain.price, quantity: 4)

    merchant_admin = bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
    admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/merchants'

    within "#merchant-#{bike_shop.id}" do
      click_link "#{bike_shop.name}"
    end

    expect(current_path).to eq("/admin/merchants/#{bike_shop.id}")

    within '#orders' do
      within "#order-#{order_1.id}" do
        expect(page).to have_link(order_1.id)
        expect(page).to have_content(order_1.created_at.strftime('%m/%d/%y'))
        expect(page).to have_content("Total Quantity: 6")
        expect(page).to have_content("Total Value: $5.50")
      end

      within "#order-#{order_2.id}" do
        expect(page).to have_link(order_2.id)
        expect(page).to have_content(order_2.created_at.strftime('%m/%d/%y'))
        expect(page).to have_content("Total Quantity: 20")
        expect(page).to have_content("Total Value: $20")
      end

      expect(page).to_not have_content(order_3.id)
      expect(page).to_not have_content(order_4.id)
    end
  end
end
