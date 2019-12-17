class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :password_confirmation
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true

  has_secure_password

  enum role: ["user", "merchant_employee", "merchant_admin", "admin"]

end
