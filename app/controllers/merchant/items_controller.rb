class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(params["merchant_id"])
  end

  def new
    @merchant = Merchant.find(params["merchant_id"])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    # binding.pry

      if item.save
        # binding.pry
        redirect_to "/merchants/#{@merchant.id}/items"
      else
        flash[:error] = item.errors.full_messages.to_sentence
        # binding.pry
        # render :new
        redirect_to "/merchant/#{@merchant.id}/items/new"
      end
    end

  def item_params
    # binding.pry
    if params["image"] == ""
      params["image"]= 'https://www.broadwayjiujitsu.com/wp-content/uploads/2017/04/default-image.jpg'
      params.permit(:name,:description,:price,:inventory,:image)
    else
      params.permit(:name,:description,:price,:inventory,:image)
    end
  end
end
