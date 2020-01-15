RSpec.describe("New Order Page") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
    end
    it "I see all the information about my current cart" do
      visit "/cart"

      click_on "Checkout"

      within "#order-item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#order-item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#order-item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      expect(page).to have_content("Total: $142")
    end

    it "I see a form where I can enter my shipping info" do
      visit "/cart"
      click_on "Checkout"

      expect(page).to have_field(:name)
      expect(page).to have_field(:address)
      expect(page).to have_field(:city)
      expect(page).to have_field(:state)
      expect(page).to have_field(:zip)
      expect(page).to have_button("Create Order")
    end

    xit "when a valid coupon is applied to applicable items in cart and I checkout, the coupon id is saved to the order" do
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

      expect(page).to have_content("Total: $264.00")
      expect(page).to have_content("Discounted Total: $261.80")
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

      expect(new_order.coupon_id).to eq(coupon_1.id)
    end
  end
end
