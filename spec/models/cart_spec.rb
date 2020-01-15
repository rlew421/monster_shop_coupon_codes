require 'rails_helper'

describe 'instance methods' do
  before(:each) do
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @shifter = @bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @coupon = @bike_shop.coupons.create!(name: "Ten Percent Off", code: "NEWYEAR10", percentage_off: 10)

    @cart = Cart.new({@pull_toy.id.to_s => 1,
                        @shifter.id.to_s => 2})
  end

  it "cart total" do
    expect(@cart.total).to eq(370)
  end

  it "cart discounted total after coupon" do
    expect(@cart.discounted_total(@coupon.id)).to eq(334)
  end
end
