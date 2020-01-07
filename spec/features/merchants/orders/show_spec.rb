require 'rails_helper'

RSpec.describe "as a merchant" do
  describe "when I visit an order show page" do
    before :each do
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)


      @user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
      @merchant_admin = @bike_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)

      @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order_2 = @user.orders.create!(name: 'Mike', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 5)
      @item_order_2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 1)
      @item_order_3 = @order_1.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 10)
      @item_order_4 = @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 7)
      @item_order_5 = @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 20)
    end

    it "I see customer's name, address, and items in the order that belong to me" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)

      visit "/merchant/orders/#{@order_1.id}"

      expect(page).to have_content(@order_1.name)
      expect(page).to have_content(@order_1.address)
      expect(page).to have_content(@order_1.city)
      expect(page).to have_content(@order_1.state)
      expect(page).to have_content(@order_1.zip)

      within "item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
        expect(page).to have_content(@pull_toy.price)
        expect(page).to have_content(@item_order_2.quantity)
      end

      within "item-#{@dog_bone.id}" do
        expect(page).to have_link(@dog_bone.name)
        expect(page).to have_css("img[src*='#{@dog_bone.image}']")
        expect(page).to have_content(@dog_bone.price)
        expect(page).to have_content(@item_order_3.quantity)
      end

      expect(page).to_not have_content(@tire.name)
    end
  end
end
