class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.toggle(:enabled?).save
    if @merchant.enabled?
      flash[:notice] = "#{@merchant.name} has been enabled."
    else
      flash[:notice] = "#{@merchant.name} has been disabled."
    end
    redirect_to '/admin/merchants'
  end
end
