class AddMarketingMessageToToolkitResourceTypes < ActiveRecord::Migration
  def change
    add_column :toolkit_resource_types, :marketing_message, :boolean
  end
end
