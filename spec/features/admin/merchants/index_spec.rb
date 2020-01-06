require 'rails_helper'

RSpec.describe 'when I visit the merchant index page' do
  it "I see all merchants in system and see:
    - the merchant's name as a link
    - the merchant's city
    - the merchant's state" do

    admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/admin/merchants'

    within "#merchant-#{bike_shop.id}" do
      expect(page).to have_link(bike_shop.name)
      expect(page).to have_content(bike_shop.city)
      expect(page).to have_content(bike_shop.state)
    end

    within "#merchant-#{dog_shop.id}" do
      expect(page).to have_content(dog_shop.city)
      expect(page).to have_content(dog_shop.state)
      click_link(dog_shop.name)
    end
    expect(current_path).to eq("/admin/merchants/#{dog_shop.id}")
  end

  it "I see a disable button next to any enabled merchants and can change that merchant's account to disabled" do
    admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/admin/merchants'

    within "#merchant-#{bike_shop.id}" do
      expect(page).to have_button "Disable"
    end

    within "#merchant-#{dog_shop.id}" do
      click_button "Disable"
    end

    dog_shop.reload

    expect(current_path).to eq("/admin/merchants")

    within "#merchant-#{bike_shop.id}" do
      expect(page).to have_button "Disable"
      expect(page).to_not have_button "Enable"
    end

    within "#merchant-#{dog_shop.id}" do
      expect(page).to have_button "Enable"
      expect(page).to_not have_button "Disable"
    end

    expect(page).to have_content("#{dog_shop.name} has been disabled")

    within "#merchant-#{dog_shop.id}" do
      click_button "Enable"
    end

    expect(current_path).to eq('/admin/merchants')

    within "#merchant-#{dog_shop.id}" do
      expect(page).to have_button "Disable"
      expect(page).to_not have_button "Enable"
    end
    expect(page).to have_content("#{dog_shop.name} has been enabled")
  end

  it "when I disable an enabled merchant, all of that merchant's items are deactivated" do
    admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/admin/merchants'

    within "#merchant-#{dog_shop.id}" do
      click_button "Disable"
    end

    dog_shop.reload
    pull_toy.reload
    dog_bone.reload

    expect(pull_toy.active?).to eq(false)
    expect(dog_bone.active?).to eq(false)

    visit '/admin/merchants'

    within "#merchant-#{dog_shop.id}" do
      click_button "Enable"
    end

    dog_shop.reload
    pull_toy.reload
    dog_bone.reload

    expect(pull_toy.active?).to eq(true)
    expect(dog_bone.active?).to eq(true)
  end
end
