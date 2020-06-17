class AddHasProductSelectorToBrands < ActiveRecord::Migration[5.2]
  def change
    add_column :brands, :has_product_selector, :boolean
  end
end
