require 'rails_helper'

RSpec.describe "Merchant Item Index Page" do
  it "can show all merchant items" do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    chain = meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    shifter = meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

    admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/merchants/#{meg.id}/items"

    within "#item-#{tire.id}" do
      expect(page).to have_content("Item name: #{tire.name}")
      expect(page).to have_content("Item description: #{tire.description}")
      expect(page).to have_content("Item price: #{tire.price}")
      expect(page).to have_content("Item inventory: #{tire.inventory}")
      expect(page).to have_content("Item status: Active")
      expect(page).to have_button("Deactivate #{tire.name}")
      expect(page).to have_css("img[src*='#{tire.image}']")
    end

    within "#item-#{chain.id}" do
      expect(page).to have_content("Item name: #{chain.name}")
      expect(page).to have_content("Item description: #{chain.description}")
      expect(page).to have_content("Item price: #{chain.price}")
      expect(page).to have_content("Item inventory: #{chain.inventory}")
      expect(page).to have_content("Item status: Active")
      expect(page).to have_button("Deactivate #{chain.name}")
      expect(page).to have_css("img[src*='#{chain.image}']")
    end

    within "#item-#{shifter.id}" do
      expect(page).to have_content("Item name: #{shifter.name}")
      expect(page).to have_content("Item description: #{shifter.description}")
      expect(page).to have_content("Item price: #{shifter.price}")
      expect(page).to have_content("Item inventory: #{shifter.inventory}")
      expect(page).to have_content("Item status: Inactive")
      expect(page).to have_button("Enable #{shifter.name}")
      expect(page).to have_button("Delete #{shifter.name}")
      expect(page).to have_css("img[src*='#{shifter.image}']")
    end
  end
end
