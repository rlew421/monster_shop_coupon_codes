require 'rails_helper'

RSpec.describe "as an admin" do
  before :each do
    @user_1 = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    @user_2 = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user2@user2.com", password: "user2", password_confirmation: "user")
    @user_3 = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user3@user3.com", password: "user3", password_confirmation: "user")
    @user_4 = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user4@user4.com", password: "user4", password_confirmation: "user")

    @merchant_employee = User.create!(name: "Merchant Employee", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_employee@merchant_employee.com", password: "merchant_employee", password_confirmation: "merchant_employee", role: 1)
    @merchant_admin = User.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)


    @admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)
    @admin_2 = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin2@admin.com", password: "admin", password_confirmation: "admin", role: 3)
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
end


# As an admin user
# When I click the "Users" link in the nav (only visible to admins)
# Then my current URI route is "/admin/users"
# Only admin users can reach this path.
# I see all users in the system
# Each user's name is a link to a show page for that user ("/admin/users/5")
# Next to each user's name is the date they registered
# Next to each user's name I see what type of user they are
