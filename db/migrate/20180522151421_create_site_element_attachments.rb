class CreateSiteElementAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :site_element_attachments do |t|
      t.integer :site_element_id
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at

      t.timestamps
    end
    add_index :site_element_attachments, :site_element_id
  end
end
