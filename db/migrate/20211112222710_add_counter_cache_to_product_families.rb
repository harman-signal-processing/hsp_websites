class AddCounterCacheToProductFamilies < ActiveRecord::Migration[6.1]
  def change
    add_column :product_families, :locale_product_families_count, :integer
  end
end
