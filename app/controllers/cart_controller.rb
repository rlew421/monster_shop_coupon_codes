class CartController < ApplicationController
  before_action :not_admin?

  def add_item
    if request.referrer.include? "cart"
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    redirect_to '/cart'
    else
      item = Item.find(params[:item_id])
      cart.add_item(item.id.to_s)
      flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
    end
  end

  def show
    @items = cart.items
    @coupon = session[:coupon_id]
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def remove_item_quantity
    if session[:cart][params[:item_id]] < 2
      session[:cart].delete(params[:item_id])
      redirect_to '/cart'
    else
      session[:cart][params[:item_id]] -= 1
      redirect_to '/cart'
    end
  end

  # def increment_decrement
  #   if params[:increment_decrement] == "increment"
  #     cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
  #   elsif params[:increment_decrement] == "decrement"
  #     cart.subtract_quantity(params[:item_id])
  #     return remove_item if cart.quantity_zero?(params[:item_id])
  #   end
  #   redirect_to "/cart"
  # end

  def apply_coupon
    coupon = Coupon.find_by(code: params[:code])
    # binding.pry
    if coupon
      session[:coupon_id] = coupon.id
      flash[:success] = "#{coupon.name} has been applied!"
    end
    redirect_to '/cart'
  end

  private

    def not_admin?
      if current_user
        render file: '/public/404' unless !current_user.admin?
      end
    end
end
