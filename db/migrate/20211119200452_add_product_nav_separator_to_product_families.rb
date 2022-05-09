class AddProductNavSeparatorToProductFamilies < ActiveRecord::Migration[6.1]
  def change
    add_column :product_families, :product_nav_separator, :string
  end
end
