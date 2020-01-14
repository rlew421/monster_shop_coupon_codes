class Merchant::CouponsController < Merchant::BaseController
  def index
    @merchant = Merchant.find_by(params[id: :merchant_id])
  end

  def show
  end
end
