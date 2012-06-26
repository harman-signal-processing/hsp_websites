class CreateRegisteredDownloads < ActiveRecord::Migration
  def self.up
    create_table :registered_downloads do |t|
      t.string :name
      t.integer :brand_id
      t.string :protected_software_file_name
      t.integer :protected_software_file_size
      t.string :protected_software_content_type
      t.datetime :protected_software_updated_at
      t.integer :download_count
      t.text :html_template
      t.text :intro_page_content
      t.text :confirmation_page_content
      t.text :email_template
      t.text :download_page_content
      t.string :url
      t.string :valid_code
      t.integer :per_download_limit

      t.timestamps
    end
  end

  def self.down
    drop_table :registered_downloads
  end
end
