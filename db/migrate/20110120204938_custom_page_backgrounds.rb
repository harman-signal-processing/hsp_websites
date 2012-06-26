class CustomPageBackgrounds < ActiveRecord::Migration
  def self.up
    add_column :products, :background_image_file_name, :string
    add_column :products, :background_image_file_size, :integer
    add_column :products, :background_image_content_type, :string
    add_column :products, :background_image_updated_at, :datetime
    add_column :products, :background_color, :string
    add_column :product_families, :background_image_file_name, :string
    add_column :product_families, :background_image_file_size, :integer
    add_column :product_families, :background_image_content_type, :string
    add_column :product_families, :background_image_updated_at, :datetime
    add_column :product_families, :background_color, :string
  end

  def self.down
    remove_column :product_families, :background_color
    remove_column :product_families, :background_image_updated_at
    remove_column :product_families, :background_image_content_type
    remove_column :product_families, :background_image_file_size
    remove_column :product_families, :background_image_file_name
    remove_column :products, :background_color
    remove_column :products, :background_image_updated_at
    remove_column :products, :background_image_content_type
    remove_column :products, :background_image_file_size
    remove_column :products, :background_image_file_name
  end
end