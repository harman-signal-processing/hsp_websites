class AddHasProductsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_products, :boolean
  end
end
