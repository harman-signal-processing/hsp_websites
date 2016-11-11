class CreateBrandSolutions < ActiveRecord::Migration
  def change
    create_table :brand_solutions do |t|
      t.integer :brand_id
      t.integer :solution_id

      t.timestamps null: false
    end
    add_index :brand_solutions, :brand_id
    add_index :brand_solutions, :solution_id
  end
end
