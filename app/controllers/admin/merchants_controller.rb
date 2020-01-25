class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.toggle(:enabled?).save
    if @merchant.enabled?
      flash[:notice] = "#{@merchant.name} has been enabled."
      @merchant.items.activate_items
    else
      flash[:notice] = "#{@merchant.name} has been disabled."
      @merchant.items.deactivate_items
    end
    redirect_to '/admin/merchants'
  end
end
