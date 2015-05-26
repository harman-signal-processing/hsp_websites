class AddProductPageUrlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_page_url, :string
  end
end
