class AddHideProductPhotoToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :hide_product_photo, :boolean, default: false
  end
end