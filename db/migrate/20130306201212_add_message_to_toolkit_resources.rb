class AddMessageToToolkitResources < ActiveRecord::Migration
  def change
    add_column :toolkit_resources, :message, :text
  end
end
