class AddExternalUrlToSiteElements < ActiveRecord::Migration
  def change
    add_column :site_elements, :external_url, :string
  end
end
