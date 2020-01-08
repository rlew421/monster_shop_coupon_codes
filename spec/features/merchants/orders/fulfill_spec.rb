require 'rails_helper'

RSpec.describe "when I visit an order show page from my dashboard" do
  describe "for each of my items in that order that has not been fulfilled and the user's desired quantity is equal to or less than my current inventory for that item, I see a button or link to fulfill that item" do
    it "I can click on that item and:
    - am returned the item show page
    - see the item is now fulfilled
    - see a flash message indicating item has been fulfilled
    - see that the item's inventory quantity is permanently reduced by the user's desired remove_item_quantity" do

      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      merchant_admin = dog_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")

      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 5)
      item_order_2 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 1)
      item_order_3 = order_1.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 10)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit "/merchant/orders/#{order_1.id}"

      expect(page).to_not have_content(tire.name)

      within "#item-#{dog_bone.id}" do
        click_link "Fulfill #{dog_bone.name}"
      end

      expect(current_path).to eq("/merchants/orders/#{order_1.id}")

      within "#item-#{dog_bone.id}" do
        expect(page).to_not have_link("Fulfill #{dog_bone.name}")
        expect(page).to have_content("Fulfilled")
        expect(page).to have_content("11")
      end

      expect(dog_bone.quantity).to eq(11)
      expect(page).to have_content("You have fulfilled #{dog_bone.name}")

      within "#item-#{dog_bone.id}" do
        expect(page).to have_link("Fulfill #{pull_toy.name}")
        expect(page).to have_content("Unfulfilled")
        expect(page).to have_content("32")
      end
    end
  end
end
