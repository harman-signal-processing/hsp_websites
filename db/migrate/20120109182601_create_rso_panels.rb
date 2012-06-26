class CreateRsoPanels < ActiveRecord::Migration
  def self.up
    create_table :rso_panels do |t|
      t.string :name
      t.integer :brand_id
      t.text :content
      t.string :rso_panel_image_file_name
      t.string :rso_panel_image_content_type
      t.integer :rso_panel_image_file_size
      t.datetime :rso_panel_image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :rso_panels
  end
end
