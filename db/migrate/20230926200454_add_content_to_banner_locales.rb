class AddContentToBannerLocales < ActiveRecord::Migration[7.0]
  def change
    add_column :banner_locales, :title, :string
    add_column :banner_locales, :slide_file_name, :string
    add_column :banner_locales, :slide_content_type, :string
    add_column :banner_locales, :slide_updated_at, :datetime
    add_column :banner_locales, :slide_file_size, :integer
    add_column :banner_locales, :content, :text
    add_column :banner_locales, :css, :text
    add_column :banner_locales, :link, :string
    add_column :banner_locales, :default, :boolean
  end
end
