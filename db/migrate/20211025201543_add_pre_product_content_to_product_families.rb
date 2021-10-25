class AddPreProductContentToProductFamilies < ActiveRecord::Migration[6.1]
  def change
    add_column :product_families, :before_product_content, :mediumtext
  end
end
