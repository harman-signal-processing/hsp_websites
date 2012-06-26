class CreateSiteElements < ActiveRecord::Migration
  def self.up
    create_table :site_elements do |t|
      t.string :name
      t.integer :brand_id
      t.string :resource_file_name
      t.integer :resource_file_size
      t.string :resource_content_type
      t.datetime :resource_updated_at
      t.string :resource_type
      t.boolean :show_on_public_site
      t.timestamps
    end
  end

  def self.down
    drop_table :site_elements
  end
end
