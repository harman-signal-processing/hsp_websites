class AddMarketingTaskToMarketingAttachments < ActiveRecord::Migration
  def change
    add_column :marketing_attachments, :marketing_task_id, :integer
    add_index :marketing_attachments, :marketing_task_id
  end
end
