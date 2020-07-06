class AddThumbnailAndSummaryToInstallations < ActiveRecord::Migration[5.2]
  def change
    add_column :installations, :summary, :text
    add_column :installations, :thumbnail_file_name, :string
    add_column :installations, :thumbnail_content_type, :string
    add_column :installations, :thumbnail_file_size, :integer
    add_column :installations, :thumbnail_updated_at, :datetime
  end
end
