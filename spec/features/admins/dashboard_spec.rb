require 'rails_helper'

RSpec.describe "admin dashboard" do
  before :each do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @bike = @meg.items.create(name: "Cool Bike", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pedal = @meg.items.create(name: "Pedal", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @brake = @meg.items.create(name: "Brake", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @handlebar = @meg.items.create(name: "Handlebar", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @helmet = @meg.items.create(name: "Helmet", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    @order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
    @order_2 = @user.orders.create!(name: 'Mike', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 1)
    @order_3 = @user.orders.create!(name: 'Person', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 2)
    @item_order_1 = @order_1.item_orders.create!(item: @bike, price: @bike.price, quantity: 1)
    @item_order_2 = @order_2.item_orders.create!(item: @bike, price: @bike.price, quantity: 20)
    @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 5)
    @item_order_2 = @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 7)
    @item_order_1 = @order_1.item_orders.create!(item: @pedal, price: @pedal.price, quantity: 10)
    @item_order_3 = @order_3.item_orders.create!(item: @handlebar, price: @handlebar.price, quantity: 6)
    @item_order_3 = @order_3.item_orders.create!(item: @helmet, price: @handlebar.price, quantity: 4)
    @item_order_3 = @order_3.item_orders.create!(item: @brake, price: @brake.price, quantity: 2)
  end

  it "displays all orders in the system categorized by order status" do
    admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/admin'

    within "#order-#{@order_1.id}" do
      expect(page).to have_link(@order_1.name)
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at.strftime('%m/%d/%Y'))
    end

    within "#pending" do
      expect(page).to have_link(@order_1.name)
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at.strftime('%m/%d/%Y'))
      expect(page).to_not have_content(@order_2.name)
      expect(page).to_not have_content(@order_3.name)
    end

    within "#packaged" do
      expect(page).to have_link(@order_2.name)
      expect(page).to have_content(@order_2.id)
      expect(page).to have_content(@order_2.created_at.strftime('%m/%d/%Y'))
      expect(page).to_not have_content(@order_1.name)
      expect(page).to_not have_content(@order_3.name)
    end

    within "#shipped" do
      expect(page).to have_link(@order_3.name)
      expect(page).to have_content(@order_3.id)
      expect(page).to have_content(@order_3.created_at.strftime('%m/%d/%Y'))
      expect(page).to_not have_content(@order_1.name)
      expect(page).to_not have_content(@order_2.name)
      click_on "#{@order_3.name}"
    end

    expect(current_path).to eq("/admin/users/#{@order_3.user.id}")
  end

  it "has a button next to all packaged orders for the admin to ship the order" do
    admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    order_4 = @user.orders.create!(name: 'Shipme', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: 1)

    visit "/admin"

    within '#packaged' do
      within "#order-#{@order_2.id}" do
        expect(page).to have_link("Ship Order")
      end

      within "#order-#{order_4.id}" do
        click_on "Ship Order"
      end
    end

    order_4.reload

    expect(order_4.status).to eq("shipped")

    within "#packaged" do
      expect(page).to_not have_content(order_4.name)
    end
  end
end
