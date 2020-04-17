class CreateBrandSpecificationForComparisons < ActiveRecord::Migration[5.2]
  def change
    create_table :brand_specification_for_comparisons do |t|
      t.integer :brand_id
      t.integer :specification_id
      t.integer :position

      t.timestamps
    end
    add_index :brand_specification_for_comparisons, :brand_id
    add_index :brand_specification_for_comparisons, :specification_id
  end
end
