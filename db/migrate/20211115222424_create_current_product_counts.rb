class CreateCurrentProductCounts < ActiveRecord::Migration[6.1]
  def change
    create_table :current_product_counts do |t|
      t.integer :product_family_id
      t.string :locale
      t.integer :current_products_plus_child_products_count

      t.timestamps
    end
    add_index :current_product_counts, :product_family_id
  end
end
