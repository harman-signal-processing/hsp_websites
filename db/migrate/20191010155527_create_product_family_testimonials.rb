class CreateProductFamilyTestimonials < ActiveRecord::Migration[5.2]
  def change
    create_table :product_family_testimonials do |t|
      t.integer :product_family_id
      t.integer :testimonial_id
      t.integer :position

      t.timestamps
    end
    add_index :product_family_testimonials, :product_family_id
    add_index :product_family_testimonials, :testimonial_id
  end
end
