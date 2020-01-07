
class Order <ApplicationRecord
  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  enum status: ["pending", "packaged", "shipped", "cancelled"]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    item_orders.sum('quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def self.status(status_searching_for)
    # can take argument of "packaged", "pending", "shipped", or "cancelled"
    where(status: "#{status_searching_for}")
  end

  def fulfill
    current_order = Order.find(self.id)
    if current_order.item_orders.all?{|item_order| item_order[:status] == 'fulfilled' }
      current_order.update(status: 1)
    end
  end

  def merchant_item_orders(merchant_id)
    item_orders.where(merchant_id: merchant_id)
    # item_orders.where("items.merchant_id = #{merchant_id}")
    # SELECT * FROM item_orders JOIN items ON items.id = item_orders.item_id WHERE items.merchant_id = #{merchant_id};
  end
end
