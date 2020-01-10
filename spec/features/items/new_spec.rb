require 'rails_helper'

RSpec.describe "Create Merchant Items" do
  describe "When I visit the merchant items index page" do
    before(:each) do
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @merchant_admin = @brian.users.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
    end

    it 'I see a link to add a new item for that merchant' do
      visit "/merchant/#{@brian.id}/items"

      expect(page).to have_link "New Item"
    end

    it 'I can add a new item by filling out a form' do
      visit "/merchant/#{@brian.id}/items"

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      click_on "New Item"

      expect(current_path).to eq("/merchant/#{@brian.id}/items/new")
      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"

      new_item = Item.last

      expect(current_path).to eq("/merchants/#{@brian.id}/items")
      expect(new_item.name).to eq(name)
      expect(new_item.price).to eq(price)
      expect(new_item.description).to eq(description)
      expect(new_item.image).to eq(image_url)
      expect(new_item.inventory).to eq(inventory)
      expect(new_item.active?).to be(true)

      expect("#item-#{Item.last.id}").to be_present
      expect(page).to have_content(name)
      expect(page).to have_content("Item price: $#{new_item.price}")
      expect(page).to have_css("img[src*='#{new_item.image}']")
      expect(page).to have_content("Active")
      expect(page).to have_content(new_item.description)
      expect(page).to have_content("Item inventory: #{new_item.inventory}")
    end

    it 'I get an alert if I dont fully fill out the form' do
      visit "/merchant/#{@brian.id}/items/new"

      name = ""
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = ""


      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"

      expect(page).to have_content("Name can't be blank, Inventory can't be blank, and Inventory is not a number")
      expect(page).to have_button("Create Item")
    end

    it "I see a link to view my own items" do
      visit '/merchant'

      click_link 'View My Items'

      expect(current_path).to eq("/merchant/#{@brian.id}/items")
    end

    it "I see a link to add new items and can't add without name" do

      visit '/merchant'

      click_link 'View My Items'

      click_link "New Item"

      expect(current_path).to eq("/merchant/#{@brian.id}/items/new")

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDitgL._SX569_.jpg"
      inventory = 25

      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_on 'Create Item'

      expect(page).to have_content("Name can't be blank")
    end

    it "I see a link to add new items and can add it without an image" do

      visit '/merchant'

      click_link 'View My Items'

      click_link "New Item"

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDitgL._SX569_.jpg"
      inventory = 25

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :inventory, with: inventory

      click_on 'Create Item'

      expect(page).to_not have_content("Name can't be blank")

      expect(current_path).to eq("/merchants/#{@brian.id}/items")
    end

    it "I see a link to add new items and price cant be lower than 0" do
      ski_shop = Merchant.create(name: "Ski Palace", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      goggles = ski_shop.items.create(name: "Ski Goggles", description: "Prevents glare", price: 100, image: "https://www.ems.com/on/demandware.static/-/Sites-vestis-master-catalog/default/dwe81243a4/product/images/2057/019/2057019/2057019_408_alt3.jpg", inventory: 12)
      ski_boots = ski_shop.items.create(name: "Ski Boots", description: "Keeps your feet snug and secure", price: 250, image: "https://images.evo.com/imgp/700/163621/642594/rossignol-track-110-ski-boots-2020-.jpg", inventory: 12)

      merchant_employee = ski_shop.users.create!(name: "Merchant Employee", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_employee@merchant_employee.com", password: "merchant_employee", password_confirmation: "merchant_employee", role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit '/merchant'

      click_link 'View My Items'

      click_link "New Item"


      name = "Chamois Buttr"
      price = 1
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDitgL._SX569_.jpg"
      inventory = -1

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_on 'Create Item'

      expect(page).to have_content("Inventory must be greater than -1")
    end

    it "I see a link to add new items and price cant be lower than 0" do
      ski_shop = Merchant.create(name: "Ski Palace", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      goggles = ski_shop.items.create(name: "Ski Goggles", description: "Prevents glare", price: 100, image: "https://www.ems.com/on/demandware.static/-/Sites-vestis-master-catalog/default/dwe81243a4/product/images/2057/019/2057019/2057019_408_alt3.jpg", inventory: 12)
      ski_boots = ski_shop.items.create(name: "Ski Boots", description: "Keeps your feet snug and secure", price: 250, image: "https://images.evo.com/imgp/700/163621/642594/rossignol-track-110-ski-boots-2020-.jpg", inventory: 12)

      merchant_employee = ski_shop.users.create!(name: "Merchant Employee", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_employee@merchant_employee.com", password: "merchant_employee", password_confirmation: "merchant_employee", role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit '/merchant'

      click_link 'View My Items'

      click_link "New Item"

      name = "Chamois Buttr"
      price = 0
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDitgL._SX569_.jpg"
      inventory = 1

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_on 'Create Item'

      expect(page).to have_content("Price must be greater than 0")
    end

    it "when i add an item whith no image it is defaulted to a stock image" do
      ski_shop = Merchant.create(name: "Ski Palace", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      goggles = ski_shop.items.create(name: "Ski Goggles", description: "Prevents glare", price: 100, image: "https://www.ems.com/on/demandware.static/-/Sites-vestis-master-catalog/default/dwe81243a4/product/images/2057/019/2057019/2057019_408_alt3.jpg", inventory: 12)
      ski_boots = ski_shop.items.create(name: "Ski Boots", description: "Keeps your feet snug and secure", price: 250, image: "https://images.evo.com/imgp/700/163621/642594/rossignol-track-110-ski-boots-2020-.jpg", inventory: 12)

      merchant_employee = ski_shop.users.create!(name: "Merchant Employee", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_employee@merchant_employee.com", password: "merchant_employee", password_confirmation: "merchant_employee", role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit '/merchant'

      click_link 'View My Items'

      click_link "New Item"

      name = "Chamois Buttr"
      price = 2
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDitgL._SX569_.jpg"
      inventory = 3

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_on 'Create Item'

      have_css("img[src*='https://www.broadwayjiujitsu.com/wp-content/uploads/2017/04/default-image.jpg']")
    end
  end
end
