class AddShortDescriptionToProductFamilies < ActiveRecord::Migration[5.1]
  def change
    add_column :product_families, :short_description, :text
  end
end
