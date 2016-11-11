class CreateProductSolutions < ActiveRecord::Migration
  def change
    create_table :product_solutions do |t|
      t.integer :product_id
      t.integer :solution_id

      t.timestamps null: false
    end
    add_index :product_solutions, :product_id
    add_index :product_solutions, :solution_id
  end
end
