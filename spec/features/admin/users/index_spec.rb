require 'rails_helper'

RSpec.describe "as an admin" do
  before :each do
    @user_1 = User.create!(name: "Miss Solo", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    @user_2 = User.create!(name: "Mr. Two", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user2@user2.com", password: "user", password_confirmation: "user")
    @user_3 = User.create!(name: "Senor Three", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user3@user3.com", password: "user", password_confirmation: "user")
    @user_4 = User.create!(name: "Mrs. Four", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user4@user4.com", password: "user", password_confirmation: "user")

    @merchant_employee = User.create!(name: "Merchant Employee", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_employee@merchant_employee.com", password: "merchant_employee", password_confirmation: "merchant_employee", role: 1)
    @merchant_admin = User.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)


    @admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)
    @admin_2 = User.create!(name: "Admin Dos", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin2@admin.com", password: "admin", password_confirmation: "admin", role: 3)
  end

  it "I see a users link in the top navbar which brings me to the user index page" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit '/'

    click_link("Users")

    expect(current_path).to eq("/admin/users")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

    visit '/'

    expect(page).to_not have_link("Users")

    visit '/admin/users'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)

    visit '/admin/users'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end

  it "the users index page lists all users (name is link to show page), the date they registered, and the type of user they are" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit '/admin/users'

    within "#user-#{@user_1.id}" do
      expect(page).to have_link(@user_1.name)
      expect(page).to have_content(@user_1.created_at)
      expect(page).to have_content(@user_1.role)
      expect(page).to_not have_content(@user_2.name)
      expect(page).to_not have_content(@user_3.name)
      expect(page).to_not have_content(@user_4.name)
    end

    within "#user-#{@user_2.id}" do
      expect(page).to have_link(@user_2.name)
      expect(page).to have_content(@user_2.created_at)
      expect(page).to have_content(@user_2.role)
      expect(page).to_not have_content(@user_1.name)
      expect(page).to_not have_content(@user_3.name)
      expect(page).to_not have_content(@user_4.name)
    end

    within "#user-#{@merchant_admin.id}" do
      expect(page).to have_link(@merchant_admin.name)
      expect(page).to have_content(@merchant_admin.created_at)
      expect(page).to have_content(@merchant_admin.role)
      expect(page).to_not have_content(@user_1.name)
      expect(page).to_not have_content(@user_3.name)
      expect(page).to_not have_content(@user_4.name)
    end

    within "#user-#{@admin_2.id}" do
      expect(page).to have_link(@admin_2.name)
      expect(page).to have_content(@admin_2.created_at)
      expect(page).to have_content(@admin_2.role)
      expect(page).to_not have_content(@user_1.name)
      expect(page).to_not have_content(@user_3.name)
      expect(page).to_not have_content(@user_4.name)
      expect(page).to_not have_link("Edit #{@admin_2.name}'s Profile")
    end
  end
end
