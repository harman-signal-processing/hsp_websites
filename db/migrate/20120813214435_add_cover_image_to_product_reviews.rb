class AddCoverImageToProductReviews < ActiveRecord::Migration
  def change
    add_column :product_reviews, :cover_image_file_name, :string
    add_column :product_reviews, :cover_image_content_type, :string
    add_column :product_reviews, :cover_image_file_size, :integer
    add_column :product_reviews, :cover_image_updated_at, :datetime
  end
end
