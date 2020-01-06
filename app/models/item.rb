class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.popular(asc_or_desc = "desc")
    # takes argument of asc or desc. Default is to list most_popular
    Item.select('items.*, SUM(quantity) AS total_quantity').limit(5).joins(:item_orders).group('items.id').order("total_quantity #{asc_or_desc}")

    # SELECT items.*, sum(item_orders.quantity) AS total_quantity FROM items LEFT JOIN item_orders ON items.id = item_orders.item_id GROUP BY items.id;
  end

  def self.deactivate_items
    update_all(:active? => false)
  end

  def self.activate_items
    update_all(:active? => true)
  end
end
