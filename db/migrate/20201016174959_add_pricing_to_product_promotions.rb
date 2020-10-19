class AddPricingToProductPromotions < ActiveRecord::Migration[6.0]
  def change
    add_column :product_promotions, :discount, :float
    add_column :product_promotions, :discount_type, :string

    Promotion.all.each do |promo|
      promo.product_promotions.update_all(
        discount: promo.discount,
        discount_type: promo.discount_type
      )
    end
  end
end
