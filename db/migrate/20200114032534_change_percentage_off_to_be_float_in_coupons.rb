class ChangePercentageOffToBeFloatInCoupons < ActiveRecord::Migration[5.1]
  def change
    change_column :coupons, :percentage_off, :float
  end
end
