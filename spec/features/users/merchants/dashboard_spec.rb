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

    xit "if any users have pending orders containing my items I see a list of these orders that include:
    - the ID of the order, which links to the order show page
    - the date the order was made
    - the total quantity of my items in the order
    - the total value of my items for that order" do

      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")

      ski_shop = Merchant.create(name: "Ski Palace", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      goggles = ski_shop.items.create(name: "Ski Goggles", description: "Prevents glare", price: 100, image: "https://www.ems.com/on/demandware.static/-/Sites-vestis-master-catalog/default/dwe81243a4/product/images/2057/019/2057019/2057019_408_alt3.jpg", inventory: 12)
      ski_boots = ski_shop.items.create(name: "Ski Boots", description: "Keeps your feet snug and secure", price: 250, image: "https://images.evo.com/imgp/700/163621/642594/rossignol-track-110-ski-boots-2020-.jpg", inventory: 12)

      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      item_order_1 = order_1.item_orders.create!(item: goggles, price: goggles.price, quantity: 2)
      item_order_2 = order_1.item_orders.create!(item: ski_boots, price: ski_boots.price, quantity: 5)
      item_order_3 = order_2.item_orders.create!(item: ski_boots, price: ski_boots.price, quantity: 2)

      merchant_employee = ski_shop.users.create!(name: "Merchant Employee", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_employee@merchant_employee.com", password: "merchant_employee", password_confirmation: "merchant_employee", role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit '/merchant'

      within "#order-#{order_1.id}" do
        expect(page).to have_content("Order ID: #{order_1.id}")
        expect(page).to have_content("Order Creation Date: #{order_1.created_at}")
        expect(page).to have_content("Total Quantity of My Ordered Items: 7")
        expect(page).to have_content("Total Value of My Ordered Items: $1450.00")
      end

      within "#order-#{order_2.id}" do
        expect(page).to have_content("Order ID: #{order_2.id}")
        expect(page).to have_content("Order Creation Date: #{order_2.created_at}")
        expect(page).to have_content("Total Quantity of My Ordered Items: 2")
        expect(page).to have_content("Total Value of My Ordered Items: $500.00")
      end
    end
  end
end
