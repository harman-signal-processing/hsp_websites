class AddHomepageBannerToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :homepage_banner_file_name, :string
    add_column :promotions, :homepage_banner_content_type, :string
    add_column :promotions, :homepage_banner_file_size, :integer
    add_column :promotions, :homepage_banner_updated_at, :datetime
  end
end
