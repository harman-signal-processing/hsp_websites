class CreateInnovations < ActiveRecord::Migration[6.1]
  def change
    create_table :innovations do |t|
      t.integer :brand_id
      t.integer :position
      t.string :name
      t.string :icon_file_name
      t.integer :icon_file_size
      t.string :icon_content_type
      t.datetime :icon_updated_at
      t.text :short_description
      t.mediumtext :description
      t.string :cached_slug

      t.timestamps
    end
    add_index :innovations, :brand_id
    add_index :innovations, :cached_slug
  end
end
