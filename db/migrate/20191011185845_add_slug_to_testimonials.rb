class AddSlugToTestimonials < ActiveRecord::Migration[5.2]
  def change
    add_column :testimonials, :cached_slug, :string
    add_index :testimonials, :cached_slug
  end
end
