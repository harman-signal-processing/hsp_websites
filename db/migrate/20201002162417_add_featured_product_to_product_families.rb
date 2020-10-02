class AddFeaturedProductToProductFamilies < ActiveRecord::Migration[6.0]
  def change
    add_column :product_families, :featured_product_id, :integer
  end
end
