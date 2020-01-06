
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        expect(page).to have_link('Register')
        expect(page).to have_link('Log In')
        expect(page).to_not have_link('Log Out')
      end
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end
  end

  describe "as a logged in user" do
    it "I see all the links a visitor would see along with a link to my profile and link to logout" do
      user = User.create!(name: "Polly Esther", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "veryoriginalemail@gmail.com", password: "polyester", password_confirmation: "polyester")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/'

      within 'nav' do
        expect(page).to have_content("Logged in as Polly Esther")
        click_link "Profile"
      end
      expect(current_path).to eq("/profile")

      within 'nav' do
        expect(page).to_not have_link('Login')
        expect(page).to_not have_link('Register')
        click_link "Log Out"
      end
      expect(current_path).to eq("/")
    end
  end

  describe "as a merchant" do
    it "I see the same links as a regular user plus a link to my merchant dashboard" do
      merchant = User.create!(name: "Ima Merchant", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "veryoriginalemail@gmail.com", password: "polyester", password_confirmation: "polyester", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit '/'

      within 'nav' do
        click_link "Dashboard"
      end

      expect(current_path).to eq("/merchant")
    end
  end

  describe "as an admin" do
    it "I see the same links as a regular user plus links to my admin dashboard and link to see all users" do
      admin = User.create!(name: "Im N. Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "veryoriginalemail@gmail.com", password: "polyester", password_confirmation: "polyester", role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit '/'

      within 'nav' do
        expect(page).to_not have_link('Cart: 0')
        click_link "Dashboard"
      end

      expect(current_path).to eq("/admin")

      within 'nav' do
        click_link "See All Users"
      end
      expect(current_path).to eq("/admin/users")

      within 'nav' do
        click_link "All Merchants"
      end
      expect(current_path).to eq("/admin/merchants")
    end
  end
end
