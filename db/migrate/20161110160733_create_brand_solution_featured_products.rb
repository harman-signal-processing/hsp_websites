class CreateBrandSolutionFeaturedProducts < ActiveRecord::Migration
  def change
    create_table :brand_solution_featured_products do |t|
      t.integer :brand_id
      t.integer :solution_id
      t.integer :product_id
      t.string :name
      t.string :link
      t.text :description
      t.string :image_file_name
      t.string :image_content_type
      t.datetime :image_updated_at
      t.integer :image_file_size

      t.timestamps null: false
    end
    add_index :brand_solution_featured_products, :brand_id
    add_index :brand_solution_featured_products, :solution_id
  end
end
