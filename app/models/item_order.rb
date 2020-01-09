class ItemOrder < ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  enum status: ["unfulfilled", "fulfilled"]

  def subtotal
    price * quantity
  end

  def fulfill
    self.update_column(:status, 'fulfilled')
    item.update(inventory: item.inventory - quantity)

    current_order = Order.find(self.order_id)
    if current_order.item_orders.all?{|item_order| item_order[:status] == 'fulfilled'}
      Order.fulfill(current_order.id)
    end
  end
end
