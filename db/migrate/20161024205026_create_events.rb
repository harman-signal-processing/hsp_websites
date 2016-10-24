class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.text :page_content
      t.string :cached_slug
      t.date :start_on
      t.date :end_on
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.boolean :active, default: false
      t.string :more_info_link
      t.boolean :new_window
      t.integer :brand_id

      t.timestamps null: false
    end
    add_index :events, :cached_slug, unique: true
    add_index :events, :brand_id
  end
end
