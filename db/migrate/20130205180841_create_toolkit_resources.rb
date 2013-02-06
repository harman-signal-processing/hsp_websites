class CreateToolkitResources < ActiveRecord::Migration
  def change
    create_table :toolkit_resources do |t|
      t.string :name
      t.integer :toolkit_resource_type_id
      t.integer :related_id
      t.string :tk_preview_file_name
      t.string :tk_preview_content_type
      t.integer :tk_preview_file_size
      t.datetime :tk_preview_updated_at
      t.string :download_path
      t.integer :download_file_size
      t.integer :brand_id

      t.timestamps
    end
    add_index :toolkit_resources, :related_id
    add_index :toolkit_resources, :brand_id
  end
end
