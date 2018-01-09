class CreateNewsImages < ActiveRecord::Migration[5.1]
  def change
    create_table :news_images do |t|
      t.integer :news_id
      t.boolean :hide_from_page
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
    add_index :news_images, :news_id
  end
end
