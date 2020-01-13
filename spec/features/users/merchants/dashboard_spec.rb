require 'rails_helper'

RSpec.describe "merchant dashboard" do
  describe "as a merchant admin" do
    it "displays the info of the merchant I work for" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_admin = bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit '/merchant'

      expect(page).to have_content(bike_shop.name)
      expect(page).to have_content(bike_shop.address)
      expect(page).to have_content(bike_shop.city)
      expect(page).to have_content(bike_shop.state)
      expect(page).to have_content(bike_shop.zip)
    end

  it "displays a list of pending orders that contain items I sell" do
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

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit '/merchant'

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

        within "#order-#{order_1.id}" do
          click_link "#{order_1.id}"
        end

        expect(current_path).to eq("/merchant/orders/#{order_1.id}")
      end
    end
    
    it "displays a link that takes me to a page where I can manage my coupons" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_admin = bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit '/merchant'

      click_link "Manage Coupons"

      expect(current_path).to eq('/merchant/coupons')
    end
  end

  describe "as a merchant employee" do
    it "displays the info of the merchant I work for" do
      ski_shop = Merchant.create(name: "Ski Palace", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_employee = ski_shop.users.create!(name: "Merchant Employee", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_employee@merchant_employee.com", password: "merchant_employee", password_confirmation: "merchant_employee", role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit '/merchant'

      expect(page).to have_content(ski_shop.name)
      expect(page).to have_content(ski_shop.address)
      expect(page).to have_content(ski_shop.city)
      expect(page).to have_content(ski_shop.state)
      expect(page).to have_content(ski_shop.zip)
    end
  end
end
