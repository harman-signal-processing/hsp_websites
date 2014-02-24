class AddLinkCheckToToolkitResources < ActiveRecord::Migration
  def change
    add_column :toolkit_resources, :link_good, :boolean
    add_column :toolkit_resources, :link_checked_at, :datetime
  end
end
