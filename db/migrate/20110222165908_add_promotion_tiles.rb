class AddPromotionTiles < ActiveRecord::Migration
  def self.up
    add_column :promotions, :tile_file_name, :string
    add_column :promotions, :tile_file_size, :integer
    add_column :promotions, :tile_content_type, :string
    add_column :promotions, :tile_updated_at, :datetime
  end

  def self.down
    remove_column :promotions, :tile_updated_at
    remove_column :promotions, :tile_content_type
    remove_column :promotions, :tile_file_size
    remove_column :promotions, :tile_file_name
  end
end