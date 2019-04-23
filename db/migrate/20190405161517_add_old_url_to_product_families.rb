class AddOldUrlToProductFamilies < ActiveRecord::Migration[5.2]
  def change
    add_column :product_families, :old_url, :string
    add_column :products, :old_url, :string
    add_column :news, :old_url, :string
  end
end
