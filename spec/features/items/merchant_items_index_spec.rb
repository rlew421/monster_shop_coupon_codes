require 'rails_helper'

RSpec.describe "Merchant Items Index Page" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
    end

    it 'shows me a list of that merchants items' do
      visit "merchants/#{@meg.id}/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Price: $#{@chain.price}")
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(@chain.description)
        expect(page).to have_content("Inventory: #{@chain.inventory}")
      end

      within "#item-#{@shifter.id}" do
        expect(page).to have_content(@shifter.name)
        expect(page).to have_content("Price: $#{@shifter.price}")
        expect(page).to have_css("img[src*='#{@shifter.image}']")
        expect(page).to have_content("Inactive")
        expect(page).to_not have_content(@shifter.description)
        expect(page).to have_content("Inventory: #{@shifter.inventory}")
      end
    end

    it 'merchant can deactivate item' do
      visit "merchants/#{@meg.id}/items"

      expect(page).to_not have_button("Activate #{@tire.name}")
      click_on("Deactivate #{@tire.name}")

      expect(current_path).to eq("/merchants/#{@meg.id}/items")
      expect(page).to have_content("#{@tire.name} is deactivated and no longer for sale.")

      @tire.reload

      within "#item-#{@tire.id}" do
        expect(page).to have_content("Item status: Inactive")
      end
    end

    it "merchant can activate an item" do
      visit "merchants/#{@meg.id}/items"
      expect(page).to_not have_button("Deactivate #{@shifter.name}")

      click_on("Enable #{@shifter.name}")
      expect(current_path).to eq("/merchants/#{@meg.id}/items")
      expect(page).to have_content("#{@shifter.name} is active and available for sale.")

      @shifter.reload

      within "#item-#{@shifter.id}" do
        expect(page).to have_content("Item status: Active")
      end
    end

    it "merchant can delete an item that has never been ordered" do
      user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user4@user.com", password: "user", password_confirmation: "user")
      order_1 = user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 5)

      visit "merchants/#{@meg.id}/items"

      expect(page).to_not have_button("Delete #{@tire.name}")
      click_on("Delete #{@shifter.name}")
      expect(current_path).to eq("/merchants/#{@meg.id}/items")
      expect(page).to have_content("#{@shifter.name} has been deleted.")
    end
  end
end
