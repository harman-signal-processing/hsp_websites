class AddPostContentToProductFamilies < ActiveRecord::Migration[5.1]
  def change
    add_column :product_families, :post_content, :text
  end
end
