class Merchant::CouponsController < Merchant::BaseController
  def index
    @merchant = Merchant.find_by(params[id: :merchant_id])
  end

  def show
    @coupon = Coupon.find(params[:coupon_id])
  end
end
