class AddImagesToIntroPages < ActiveRecord::Migration
  def change
  	add_column :product_introductions, :top_image_file_name, :string
  	add_column :product_introductions, :top_image_file_size, :integer
  	add_column :product_introductions, :top_image_content_type, :string
  	add_column :product_introductions, :top_image_updated_at, :datetime
  	add_column :product_introductions, :box_bg_image_file_name, :string
  	add_column :product_introductions, :box_bg_image_file_size, :integer
  	add_column :product_introductions, :box_bg_image_content_type, :string
  	add_column :product_introductions, :box_bg_image_updated_at, :datetime
  	add_column :product_introductions, :page_bg_image_file_name, :string
  	add_column :product_introductions, :page_bg_image_file_size, :integer
  	add_column :product_introductions, :page_bg_image_content_type, :string
  	add_column :product_introductions, :page_bg_image_updated_at, :datetime
  end
end
