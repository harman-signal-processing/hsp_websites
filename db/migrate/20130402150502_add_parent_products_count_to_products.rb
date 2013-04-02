class AddParentProductsCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :parent_products_count, :integer, default: 0, null: false
  end
end
