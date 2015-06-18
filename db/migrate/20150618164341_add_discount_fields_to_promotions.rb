class AddDiscountFieldsToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :discount, :float
    add_column :promotions, :discount_type, :string
    add_column :promotions, :show_recalculated_price, :boolean
  end
end
