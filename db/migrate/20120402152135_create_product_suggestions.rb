class CreateProductSuggestions < ActiveRecord::Migration
  def change
    create_table :product_suggestions do |t|
      t.integer :product_id
      t.integer :suggested_product_id
      t.integer :position

      t.timestamps
    end
  end
end
