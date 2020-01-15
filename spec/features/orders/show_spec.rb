require 'rails_helper'

RSpec.describe "Order show page", type: :feature do
  it "can show a specific order" do
    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user1@user.com", password: "user", password_confirmation: "user")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    item_order_1 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 1)
    item_order_2 = order_1.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 10)

    items_array = [ item_order_1, item_order_2]
    visit "/profile/orders"

    click_on("Order Number: #{order_1.id}")
    expect(current_path).to eq("/profile/orders/#{order_1.id}")

    expect(page).to have_content("Order ID: #{order_1.id}")
    expect(page).to have_content("Order creation date: #{order_1.created_at.strftime('%m/%d/%Y')}")
    expect(page).to have_content("Order updated on: #{order_1.updated_at.strftime('%m/%d/%Y')}")
    expect(page).to have_content("Order status: #{order_1.status}")
    expect(page).to have_content("Total items ordered: 11")
    expect(page).to have_content("Order total: $220.00")

    within "#item-#{item_order_1.item_id}" do
      expect(page).to have_content(item_order_1.item.name)
      expect(page).to have_content(item_order_1.item.description)
      expect(page).to have_content(item_order_1.quantity)
      expect(page).to have_content(item_order_1.item.price)
      click_on "#{item_order_1.item.id}-photo"
      expect(current_path).to eq("/items/#{item_order_1.item_id}")
    end

  visit "/profile/orders/#{order_1.id}"
    within "#item-#{item_order_2.item_id}" do
      expect(page).to have_content(item_order_2.item.name)
      expect(page).to have_content(item_order_2.item.description)
      expect(page).to have_content(item_order_2.quantity)
      expect(page).to have_content(item_order_2.item.price)
      click_on "#{item_order_2.item.id}-photo"
      expect(current_path).to eq("/items/#{item_order_2.item_id}")
    end
  end

  xit "when a coupon is applied, order show page can display which coupon was used and discounted price of the order" do
    new_store = Merchant.create(name: "New Store", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    other_store = Merchant.create(name: "Other Store", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

    item_1 = new_store.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    item_2 = new_store.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    item_3 = other_store.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    coupon_1 = new_store.coupons.create!(name: "Ten Percent Off", code: "NEWYEAR10", percentage_off: 10)
    coupon_2 = other_store.coupons.create!(name: "Fifteen Percent Off", code: "NEWYEAR15", percentage_off: 15)

    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/items/#{item_1.id}"
    click_on "Add To Cart"
    visit "/items/#{item_2.id}"
    click_on "Add To Cart"
    visit "/items/#{item_3.id}"
    click_on "Add To Cart"

    visit '/cart'

    fill_in :code, with: "NEWYEAR10"
    click_button "Apply Coupon Code"

    expect(current_path).to eq('/cart')

    expect(page).to have_content("Total: $122.00")
    expect(page).to have_content("Discounted Total: $119.80")
    click_on "Checkout"

    name = "Bert"
    address = "123 Sesame St."
    city = "NYC"
    state = "New York"
    zip = 10001

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip

    click_button "Create Order"

    new_order = Order.last

    expect(current_path).to eq("/profile/orders")


    expect(page).to have_content("Discounted Total: $119.80")
    expect(page).to have_content("Coupon Applied: Ten Percent Off")
  end
end
