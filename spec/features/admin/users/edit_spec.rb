require 'rails_helper'

RSpec.describe 'admin can perform the same actions that a user can and also change their role to merchant' do
  describe 'as an admin I can access an index of all default users' do
    it "I can edit a default user's profile" do
      admin = User.create!(name: "Admin",
                          address: "1230 East Street",
                          city: "Boulder", state: "CO",
                          zip: 98273,
                          email: "admin@admin.com",
                          password: "admin",
                          password_confirmation: "admin", role: 3)

      user_1 = User.create!(name: "User 1",
                            address: "User 1 Street",
                            city: "Denver",
                            state: "CO",
                            zip: 80207,
                            email: "user1@user.com",
                            password: "user1",
                            password_confirmation: "user1")

      merchant_admin = User.create!(name: "Ima M. Admin",
                                    address: "1230 East Street",
                                    city: "Boulder",
                                    state: "CO",
                                    zip: 98273,
                                    email: "merchant_admin@merchant_admin.com",
                                    password: "merchant_admin",
                                    password_confirmation: "merchant_admin", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit '/'

      within 'nav' do
        click_link "Users"
      end

      expect(current_path).to eq('/admin/users')
      expect(page).to_not have_content(merchant_admin.name)

      within "#user-#{user_1.id}" do
        click_link("Edit #{user_1.name}'s Profile")
      end

      expect(current_path).to eq("/admin/users/#{user_1.id}/profile/edit")

      expect(find_field(:name).value).to eq "User 1"
      expect(find_field(:address).value).to eq "User 1 Street"
      expect(find_field(:city).value).to eq "Denver"
      expect(find_field(:state).value).to eq "CO"
      expect(find_field(:zip).value).to eq "80207"
      expect(find_field(:email).value).to eq "user1@user.com"

      fill_in :name, with: "Changed Name"
      fill_in :address, with: "Changed Address"
      click_button "Update #{user_1.name}'s Profile"

      expect(current_path).to eq('/admin/users')
      within "#user-#{user_1.id}" do
        expect(page).to have_content("Changed Name")
        expect(page).to_not have_content("User 1")
      end
    end

    it "I can edit a default user's password" do
      admin = User.create!(name: "Admin",
                          address: "1230 East Street",
                          city: "Boulder", state: "CO",
                          zip: 98273,
                          email: "admin@admin.com",
                          password: "admin",
                          password_confirmation: "admin", role: 3)

      user_1 = User.create!(name: "User 1",
                            address: "User 1 Street",
                            city: "Denver",
                            state: "CO",
                            zip: 80207,
                            email: "user1@user.com",
                            password: "user1",
                            password_confirmation: "user1")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit '/admin/users'

      within "#user-#{user_1.id}" do
        click_link("Edit #{user_1.name}'s Password")
      end

      expect(current_path).to eq("/admin/users/#{user_1.id}/password/edit")

      password = "newpasswordforuser"
      password_confirmation = "newpasswordforuser"

      fill_in :password, with: password
      fill_in :password_confirmation, with: password_confirmation
      click_button "Update #{user_1.name}'s Password"

      expect(current_path).to eq('/admin/users')
      expect(page).to have_content("#{user_1.name}'s password has been updated.")
    end

    it "I can upgrade a default user to a merchant by changing their role" do
      admin = User.create!(name: "Admin",
                          address: "1230 East Street",
                          city: "Boulder", state: "CO",
                          zip: 98273,
                          email: "admin@admin.com",
                          password: "admin",
                          password_confirmation: "admin", role: 3)

      user_1 = User.create!(name: "User 1",
                            address: "User 1 Street",
                            city: "Denver",
                            state: "CO",
                            zip: 80207,
                            email: "user1@user.com",
                            password: "user1",
                            password_confirmation: "user1")

      user_2 = User.create!(name: "User 2",
                            address: "User 2 Street",
                            city: "Denver",
                            state: "CO",
                            zip: 80207,
                            email: "user2@user.com",
                            password: "user2",
                            password_confirmation: "user2")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit '/admin/users'

      within "#user-#{user_1.id}" do
        click_link("Upgrade #{user_1.name} to Merchant Employee")
      end

      expect(current_path).to eq('/admin/users')
      expect(page).to_not have_css("#user-#{user_1.id}")

      within "#user-#{user_2.id}" do
        click_link("Upgrade #{user_2.name} to Merchant Admin")
      end

      expect(current_path).to eq('/admin/users')
      expect(page).to_not have_css("#user-#{user_2.id}")
    end
  end
end
