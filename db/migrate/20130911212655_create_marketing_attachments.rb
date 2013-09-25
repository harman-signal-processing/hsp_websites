class CreateMarketingAttachments < ActiveRecord::Migration
  def change
    create_table :marketing_attachments do |t|
      t.integer :marketing_project_id
      t.string :marketing_file_file_name
      t.integer :marketing_file_file_size
      t.string :marketing_file_content_type
      t.datetime :marketing_file_updated_at

      t.timestamps
    end
    add_index :marketing_attachments, :marketing_project_id
  end
end
