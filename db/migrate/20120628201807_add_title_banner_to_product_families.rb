class AddTitleBannerToProductFamilies < ActiveRecord::Migration
  def change
    add_column :product_families, :title_banner_file_name, :string
    add_column :product_families, :title_banner_content_type, :string
    add_column :product_families, :title_banner_file_size, :integer
    add_column :product_families, :title_banner_updated_at, :datetime
  end
end
