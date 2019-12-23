class Merchant::BaseController < ApplicationController
  before_action :require_merchant, only: [:show]
  before_action :require_admin_or_merchant, only: [:index]

  def require_merchant
    render file: '/public/404' unless current_user && (current_user.merchant_admin? || current_user.merchant_employee?)
  end

  def require_admin_or_merchant
    render file: '/public/404' unless current_user && (current_user.merchant_admin? || current_user.merchant_employee? || current_user.admin?)
  end
end
