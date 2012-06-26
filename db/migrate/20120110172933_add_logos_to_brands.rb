class AddLogosToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :logo_file_name, :string
    add_column :brands, :logo_content_type, :string
    add_column :brands, :logo_updated_at, :datetime
    add_column :brands, :logo_file_size, :integer
  end

  def self.down
    remove_column :brands, :logo_file_size
    remove_column :brands, :logo_updated_at
    remove_column :brands, :logo_content_type
    remove_column :brands, :logo_file_name
  end
end
