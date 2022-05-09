class AddDisplayFlagsToFeatures < ActiveRecord::Migration[6.1]
  def change
    add_column :features, :use_as_banner_slide, :boolean, default: false
    add_column :features, :show_below_products, :boolean, default: false
    add_column :features, :show_below_videos, :boolean, default: false
  end
end
