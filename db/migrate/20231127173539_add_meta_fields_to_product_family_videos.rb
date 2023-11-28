class AddMetaFieldsToProductFamilyVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :product_family_videos, :title, :string
    add_column :product_family_videos, :description, :string
    add_column :product_family_videos, :duration_seconds, :integer
    add_column :product_family_videos, :published_on, :date
  end
end
