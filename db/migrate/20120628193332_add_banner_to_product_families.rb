class AddBannerToProductFamilies < ActiveRecord::Migration
  def change
    add_column :product_families, :family_banner_file_name, :string
    add_column :product_families, :family_banner_content_type, :string
    add_column :product_families, :family_banner_file_size, :integer
    add_column :product_families, :family_banner_updated_at, :datetime
  end
end
