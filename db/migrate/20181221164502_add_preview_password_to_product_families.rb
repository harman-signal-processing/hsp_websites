class AddPreviewPasswordToProductFamilies < ActiveRecord::Migration[5.2]
  def change
    add_column :product_families, :preview_password, :string
    add_column :product_families, :preview_username, :string
  end
end
