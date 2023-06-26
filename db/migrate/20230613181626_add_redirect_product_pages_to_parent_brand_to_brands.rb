class AddRedirectProductPagesToParentBrandToBrands < ActiveRecord::Migration[7.0]
  def change
    add_column :brands, :redirect_product_pages_to_parent_brand, :boolean
  end
end
