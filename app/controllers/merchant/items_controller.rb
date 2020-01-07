class Merchant::ItemsController < Merchant::BaseController
  def index
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.find(params[:item_id])
    item.toggle(:active?).save
    if item.active?
      flash[:success] = "#{item.name} is active and available for sale."
    else
      flash[:success] = "#{item.name} is deactivated and no longer for sale."
    end
    redirect_to "/merchants/#{merchant.id}/items"
  end
end
