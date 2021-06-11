class CreateBrandDealerRentalProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :brand_dealer_rental_products do |t|
      t.bigint :brand_dealer_id, foreign_key: { to_table: :brand_dealer }
      t.bigint :product_id, foreign_key: { to_table: :product }
      t.integer :position

      t.timestamps
    end
  end
end
