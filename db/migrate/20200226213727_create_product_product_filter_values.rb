class CreateProductProductFilterValues < ActiveRecord::Migration[5.2]
  def change
    create_table :product_product_filter_values do |t|
      t.integer :product_id
      t.integer :product_filter_id
      t.string :string_value
      t.boolean :boolean_value
      t.integer :number_value

      t.timestamps
    end
    add_index :product_product_filter_values, :product_id
    add_index :product_product_filter_values, :product_filter_id
  end
end
