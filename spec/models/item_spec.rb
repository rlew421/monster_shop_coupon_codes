require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
      order_1 = user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_1.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end

  describe "class methods" do
    describe "#popular method" do
      it "defaults to returning the most popular items" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        bike = meg.items.create(name: "Cool Bike", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        pedal = meg.items.create(name: "Pedal", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        brake = meg.items.create(name: "Brake", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        handlebar = meg.items.create(name: "Handlebar", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        helmet = meg.items.create(name: "Helmet", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
        order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
        order_2 = user.orders.create!(name: 'Mike', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
        order_3 = user.orders.create!(name: 'Person', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
        item_order_1 = order_1.item_orders.create!(item: bike, price: bike.price, quantity: 1)
        item_order_2 = order_2.item_orders.create!(item: bike, price: bike.price, quantity: 20)
        item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 5)
        item_order_2 = order_2.item_orders.create!(item: tire, price: tire.price, quantity: 7)
        item_order_1 = order_1.item_orders.create!(item: pedal, price: pedal.price, quantity: 10)
        item_order_3 = order_3.item_orders.create!(item: handlebar, price: handlebar.price, quantity: 6)
        item_order_3 = order_3.item_orders.create!(item: helmet, price: handlebar.price, quantity: 4)
        item_order_3 = order_3.item_orders.create!(item: brake, price: brake.price, quantity: 2)

        expect(Item.popular.first.name).to eq(bike.name)
        expect(Item.popular.first.total_quantity).to eq(21)
        expect(Item.popular[1].name).to eq(tire.name)
        expect(Item.popular[1].total_quantity).to eq(12)
        expect(Item.popular.last.name).to eq(helmet.name)
        expect(Item.popular.last.total_quantity).to eq(4)
        expect(Item.popular.length).to eq(5)
      end

      it "can take an optional argument of 'asc' to get least popular items" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        bike = meg.items.create(name: "Cool Bike", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        pedal = meg.items.create(name: "Pedal", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        brake = meg.items.create(name: "Brake", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        handlebar = meg.items.create(name: "Handlebar", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        helmet = meg.items.create(name: "Helmet", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
        order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
        order_2 = user.orders.create!(name: 'Mike', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
        order_3 = user.orders.create!(name: 'Person', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
        item_order_1 = order_1.item_orders.create!(item: bike, price: bike.price, quantity: 1)
        item_order_2 = order_2.item_orders.create!(item: bike, price: bike.price, quantity: 20)
        item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 5)
        item_order_2 = order_2.item_orders.create!(item: tire, price: tire.price, quantity: 7)
        item_order_1 = order_1.item_orders.create!(item: pedal, price: pedal.price, quantity: 10)
        item_order_3 = order_3.item_orders.create!(item: handlebar, price: handlebar.price, quantity: 6)
        item_order_3 = order_3.item_orders.create!(item: helmet, price: handlebar.price, quantity: 4)
        item_order_3 = order_3.item_orders.create!(item: brake, price: brake.price, quantity: 2)

        expect(Item.popular("asc").first.name).to eq(brake.name)
        expect(Item.popular("asc").first.total_quantity).to eq(2)
        expect(Item.popular("asc").last.name).to eq(tire.name)
        expect(Item.popular("asc").last.total_quantity).to eq(12)
        expect(Item.popular("asc").length).to eq(5)
      end

      it "can toggle items between activated and deactivated" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        bike = meg.items.create(name: "Cool Bike", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        pedal = meg.items.create(name: "Pedal", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

        meg.items.deactivate_items

        tire.reload
        bike.reload
        pedal.reload

        expect(tire.active?).to eq(false)
        expect(bike.active?).to eq(false)
        expect(pedal.active?).to eq(false)

        meg.items.activate_items

        tire.reload
        bike.reload
        pedal.reload

        expect(tire.active?).to eq(true)
        expect(bike.active?).to eq(true)
        expect(pedal.active?).to eq(true)
      end
    end
  end
end
