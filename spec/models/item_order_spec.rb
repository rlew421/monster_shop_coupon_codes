require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    it 'subtotal' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end

    it "fulfill" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      merchant_admin = dog_shop.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")

      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg",inventory: 21)

      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_2 = user.orders.create!(name: 'Brian', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204)

      item_order_1 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2)
      item_order_2 = order_1.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 10)

      item_order_3 = order_2.item_orders.create!(item: pull_toy, price: dog_bone.price, quantity: 2)
      item_order_4 = order_2.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 2)
      item_order_5 = order_2.item_orders.create!(item: tire, price: dog_bone.price, quantity: 2)


      item_order_1.fulfill
      item_order_2.fulfill
      item_order_3.fulfill
      item_order_4.fulfill

      item_order_1.reload
      item_order_2.reload
      item_order_3.reload
      item_order_4.reload
      item_order_5.reload
      order_1.reload
      order_2.reload
      order_1.item_orders.reload
      order_2.item_orders.reload

      expect(item_order_1.status).to eq('fulfilled')
      expect(pull_toy.inventory).to eq(28)
      expect(item_order_2.status).to eq('fulfilled')
      expect(dog_bone.inventory).to eq(9)
      expect(order_1.status).to eq('packaged')

      expect(item_order_3.status).to eq('fulfilled')
      expect(item_order_4.status).to eq('fulfilled')
      expect(item_order_5.status).to eq('unfulfilled')
      expect(order_2.status).to eq('pending')
    end
  end
end
