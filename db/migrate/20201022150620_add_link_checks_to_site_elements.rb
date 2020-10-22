class AddLinkChecksToSiteElements < ActiveRecord::Migration[6.0]
  def change
    add_column :site_elements, :link_checked_at, :datetime
    add_column :site_elements, :link_status, :string
  end
end
