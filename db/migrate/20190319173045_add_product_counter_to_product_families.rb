class AddProductCounterToProductFamilies < ActiveRecord::Migration[5.2]
  def change
    add_column :product_families, :product_family_products_count, :integer
  end
end
