class CreateParentProducts < ActiveRecord::Migration
  def change
    create_table :parent_products do |t|
      t.integer :parent_product_id
      t.integer :product_id
      t.integer :position

      t.timestamps
    end
  end
end
