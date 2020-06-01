class AddMetaDescriptionToProductFamilies < ActiveRecord::Migration[5.2]
  def change
    add_column :product_families, :meta_description, :text
  end
end
