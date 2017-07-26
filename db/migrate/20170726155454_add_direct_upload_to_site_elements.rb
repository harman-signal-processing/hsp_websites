class AddDirectUploadToSiteElements < ActiveRecord::Migration[5.1]
  def change
    add_column :site_elements, :direct_upload_url, :string
    add_column :site_elements, :processed, :boolean, default: false
  end
end
