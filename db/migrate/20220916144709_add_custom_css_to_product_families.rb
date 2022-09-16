class AddCustomCssToProductFamilies < ActiveRecord::Migration[7.0]
  def change
    add_column :product_families, :custom_css, :text
  end
end
