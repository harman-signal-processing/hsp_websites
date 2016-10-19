class CreateGetStartedPages < ActiveRecord::Migration
  def change
    create_table :get_started_pages do |t|
      t.string :name
      t.string :header_image_file_name
      t.string :header_image_content_type
      t.integer :header_image_file_size
      t.datetime :header_image_updated_at
      t.text :intro
      t.text :details
      t.integer :brand_id
      t.string :cached_slug

      t.timestamps null: false
    end
    add_index :get_started_pages, :cached_slug, unique: true
  end
end
