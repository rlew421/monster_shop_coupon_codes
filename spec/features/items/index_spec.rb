require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items, merchant names, and images are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      click_on "#{@tire.id}-photo"
      expect(current_path).to eq("/items/#{@tire.id}")

      visit '/items'

      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      click_on "#{@pull_toy.id}-photo"
      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end

    it "I can see a list of all of the items that are not disabled" do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Item price: $100.00")
        expect(page).to have_content("Active")
        expect(page).to have_content("Item inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Item price: $10.00")
        expect(page).to have_content("Active")
        expect(page).to have_content("Item inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_css("#item-#{@dog_bone.id}")
      expect(page).to_not have_content("#{@dog_bone.name}")
    end
  end

  describe "it has a most popular and least popular section" do
    it "I see a section for most popular items" do
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

      visit "/items"

      within "#most-popular" do
        expect(page.all('li')[0]).to have_content(bike.name)
        expect(page.all('li')[0]).to have_content("21")
        expect(page.all('li')[1]).to have_content(tire.name)
        expect(page.all('li')[1]).to have_content("12")
        expect(page.all('li')[2]).to have_content(pedal.name)
        expect(page.all('li')[2]).to have_content("10")
        expect(page.all('li')[3]).to have_content(handlebar.name)
        expect(page.all('li')[3]).to have_content("6")
        expect(page.all('li')[4]).to have_content(helmet.name)
        expect(page.all('li')[4]).to have_content("4")
        expect(page).to_not have_content(brake.name)
      end
    end

    it "I see a section for least popular items" do
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

      visit "/items"

      within "#least-popular" do
        expect(page.all('li')[0]).to have_content(brake.name)
        expect(page.all('li')[0]).to have_content("2")
        expect(page.all('li')[1]).to have_content(helmet.name)
        expect(page.all('li')[1]).to have_content("4")
        expect(page.all('li')[2]).to have_content(handlebar.name)
        expect(page.all('li')[2]).to have_content("6")
        expect(page.all('li')[3]).to have_content(pedal.name)
        expect(page.all('li')[3]).to have_content("10")
        expect(page.all('li')[4]).to have_content(tire.name)
        expect(page.all('li')[4]).to have_content("12")
        expect(page).to_not have_content(bike.name)
      end
    end
  end
end
