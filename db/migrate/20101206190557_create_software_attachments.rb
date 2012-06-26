class CreateSoftwareAttachments < ActiveRecord::Migration
  def self.up
    create_table :software_attachments do |t|
      t.integer :software_id
      t.string :software_attachment_file_name
      t.integer :software_attachment_file_size
      t.string :software_attachment_content_type
      t.datetime :software_attachment_updated_at
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :software_attachments
  end
end
