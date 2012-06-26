class CreateProductSiteElements < ActiveRecord::Migration
  def change
    create_table :product_site_elements do |t|
      t.integer :product_id
      t.integer :site_element_id

      t.timestamps
    end
  end
end
