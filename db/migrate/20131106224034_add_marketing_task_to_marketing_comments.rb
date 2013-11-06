class AddMarketingTaskToMarketingComments < ActiveRecord::Migration
  def change
    add_column :marketing_comments, :marketing_task_id, :integer
    add_index :marketing_comments, :marketing_task_id
  end
end
