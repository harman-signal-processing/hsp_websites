class AddVideoToFeatures < ActiveRecord::Migration[7.1]
  def change
    add_column :features, :video_file_name, :string
    add_column :features, :video_content_type, :string
    add_column :features, :video_updated_at, :datetime
    add_column :features, :video_file_size, :integer
  end
end
