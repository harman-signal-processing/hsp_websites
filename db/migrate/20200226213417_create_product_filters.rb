class CreateProductFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :product_filters do |t|
      t.string :name
      t.string :value_type
      t.string :min_value
      t.string :max_value
      t.string :uom

      t.timestamps
    end
  end
end
