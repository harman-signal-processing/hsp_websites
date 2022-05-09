class AddTitleToProductFamilies < ActiveRecord::Migration[6.1]
  def change
    add_column :product_families, :title, :string
  end
end
