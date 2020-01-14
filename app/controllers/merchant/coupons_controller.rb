class Merchant::CouponsController < Merchant::BaseController
  def index
    @merchant = Merchant.find_by(params[id: :merchant_id])
  end

  def show
    @coupon = Coupon.find(params[:coupon_id])
  end

  def new
  end

  def create
    merchant = Merchant.find_by(params[id: :merchant_id])
    merchant.coupons.create(coupon_params)
    redirect_to '/merchant/coupons'
  end

  def edit
    @coupon = Coupon.find(params[:coupon_id])
  end

  def update
    coupon = Coupon.find_by(params[id: :coupon_id])
    coupon.update(coupon_params)
    redirect_to '/merchant/coupons'
  end

  def destroy
    coupon = Coupon.find(params[:coupon_id])
    coupon.destroy
    redirect_to '/merchant/coupons'
  end

  private

  def coupon_params
    params.permit(:name, :code, :percentage_off)
  end
end
