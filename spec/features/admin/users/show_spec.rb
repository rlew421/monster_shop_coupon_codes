# As an admin user
# When I visit a user's profile page ("/admin/users/5")
# I see the same information the user would see themselves
# I do not see a link to edit their profile

require 'rails_helper'

RSpec.describe "as an admin" do
  it "when I visit a user's profile, I see the same info they see but I do not see the edit profile button" do
    user = User.create!(name: "Miss Solo", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    merchant_admin = User.create!(name: "Merchant Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "merchant_admin@merchant_admin.com", password: "merchant_admin", password_confirmation: "merchant_admin", role: 2)

    admin = User.create!(name: "Admin", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "admin@admin.com", password: "admin", password_confirmation: "admin", role: 3)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit "/admin/users/#{user.id}"

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
    expect(page).to have_content(user.email)
  end
end
