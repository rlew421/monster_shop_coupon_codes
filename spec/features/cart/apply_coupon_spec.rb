require 'rails_helper'

RSpec.describe 'when I visit the cart show page' do
  it "I have the ability to add a coupon code when I have items in my cart" do
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    coupon = mike.coupons.create!(name: "Ten Percent Off", code: "NEWYEAR10", percentage_off: 10)

    visit "/items/#{pencil.id}"
    click_on "Add To Cart"

    visit '/cart'

    fill_in :code, with: "NEWYEAR10"
    click_button "Apply Coupon Code"

    expect(current_path).to eq('/cart')
  end

  it "when I enter in a coupon code, I see my discounted total" do
    new_store = Merchant.create(name: "New Store", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    other_store = Merchant.create(name: "Other Store", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

    item_1 = new_store.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    item_2 = new_store.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    item_3 = other_store.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    coupon = new_store.coupons.create!(name: "Ten Percent Off", code: "NEWYEAR10", percentage_off: 10)

    visit "/items/#{item_1.id}"
    click_on "Add To Cart"
    visit "/items/#{item_2.id}"
    click_on "Add To Cart"
    visit "/items/#{item_3.id}"
    click_on "Add To Cart"

    visit '/cart'

    within "#cart-item-#{item_1.id}" do
      expect(page).to have_content("1")
      expect(page).to have_content("$20.00")
    end
    within "#cart-item-#{item_2.id}" do
      expect(page).to have_content("1")
      expect(page).to have_content("$2.00")
    end

    fill_in :code, with: "NEWYEAR10"
    click_button "Apply Coupon Code"

    expect(current_path).to eq('/cart')

    expect(page).to have_content("#{coupon.name} has been applied!")
    expect(page).to have_content("Total: $122.00")
    expect(page).to have_content("Discounted Total: $119.80")
  end

  it "coupon persists in cart and visitor/user can add keep adding items and coupon still applies" do
    new_store = Merchant.create(name: "New Store", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    other_store = Merchant.create(name: "Other Store", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

    item_1 = new_store.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    item_2 = new_store.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    item_3 = other_store.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    coupon = new_store.coupons.create!(name: "Ten Percent Off", code: "NEWYEAR10", percentage_off: 10)

    visit "/items/#{item_1.id}"
    click_on "Add To Cart"
    visit "/items/#{item_2.id}"
    click_on "Add To Cart"
    visit "/items/#{item_3.id}"
    click_on "Add To Cart"

    visit '/cart'

    within "#cart-item-#{item_1.id}" do
      expect(page).to have_content("1")
      expect(page).to have_content("$20.00")
    end
    within "#cart-item-#{item_2.id}" do
      expect(page).to have_content("1")
      expect(page).to have_content("$2.00")
    end

    fill_in :code, with: "NEWYEAR10"
    click_button "Apply Coupon Code"

    expect(current_path).to eq('/cart')

    visit "/items/#{item_1.id}"
    click_on "Add To Cart"

    visit '/cart'

    expect(page).to have_content("Total: $142.00")
    expect(page).to have_content("Discounted Total: $137.80")
  end
end
