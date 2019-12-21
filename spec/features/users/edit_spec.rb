require 'rails_helper'

RSpec.describe 'User profile page' do
  it "I can see a link to edit my profile" do

    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile'

    click_on("Edit your profile")
    expect(current_path).to eq('/profile/edit')
  end

  it "I can click a link that allows me to edit my profile through a form" do
    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile'

    click_link "Edit your profile"

    expect(find_field('Name').value).to eq "User"
    expect(find_field('Address').value).to eq "1230 East Street"
    expect(find_field('City').value).to eq "Boulder"
    expect(find_field('State').value).to eq "CO"
    expect(find_field('Zip').value).to eq '98273'
    expect(find_field('Email').value).to eq "user@user.com"

    fill_in :name, with: "Changed User"
    fill_in :address, with: "90210 Different Address Dr."
    fill_in :city, with: "Different City"
    fill_in :state, with: "TX"
    fill_in :zip, with: 70291
    click_button "Update My Profile"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your profile has been updated.")
    expect(page).to have_content("Changed User")
    expect(page).to have_content("90210 Different Address Dr.")
    expect(page).to have_content("Different City")
    expect(page).to have_content("TX")
    expect(page).to have_content("70291")
    expect(page).to have_content("user@user.com")

    click_link "Edit your profile"
    fill_in :name, with: "Changed my name again"
    click_button "Update My Profile"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Changed my name again")
    expect(page).to have_content("90210 Different Address Dr.")
    expect(page).to_not have_content("Changed User")
  end

  it "I can click a link that allows me to edit my password through a form" do
    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")

    visit '/'

    within '.topnav' do
      click_link "Log In"
    end

    fill_in :email, with: "user@user.com"
    fill_in :password, with: "user"
    click_button "Log In"

    within '.topnav' do
      click_link "Profile"
    end

    click_link "Edit your password"

    password = "newpassword"
    password_confirmation = "newpassword"

    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button "Update My Password"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your password has been updated.")

    within '.topnav' do
      click_link "Log Out"
    end

    visit '/'

    click_link "Log In"

    fill_in :email, with: "user@user.com"
    fill_in :password, with: "newpassword"
    click_button 'Log In'
    expect(current_path).to eq('/profile')
  end

  it "I must enter a unique email when I try to edit my profile or I receive an error message" do
    user = User.create!(name: "User", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "user@user.com", password: "user", password_confirmation: "user")
    user_2 = User.create!(name: "User 2", address: "1230 East Street", city: "Boulder", state: "CO", zip: 98273, email: "another_user@user.com", password: "user2", password_confirmation: "user2")

    visit '/'

    within '.topnav' do
      click_link "Log In"
    end

    fill_in :email, with: "user@user.com"
    fill_in :password, with: "user"
    click_button "Log In"

    within '.topnav' do
      click_link "Profile"
    end

    click_link "Edit your profile"

    fill_in :name, with: "Changed User"
    fill_in :address, with: "90210 Different Address Dr."
    fill_in :city, with: "Different City"
    fill_in :state, with: "TX"
    fill_in :zip, with: 70291
    fill_in :email, with: "another_user@user.com"
    click_button "Update My Profile"

    expect(current_path).to eq('/profile')
    expect(page).to have_content('Email has already been taken')
  end
end
