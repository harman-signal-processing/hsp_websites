class CreateProductVideos < ActiveRecord::Migration
  def change
    create_table :product_videos do |t|
      t.integer :product_id
      t.string :youtube_id
      t.string :group
      t.integer :position

      t.timestamps null: false
    end
    add_index :product_videos, :product_id
  end
end
