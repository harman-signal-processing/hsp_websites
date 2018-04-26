class AddAccessToSiteElements < ActiveRecord::Migration[5.1]
  def change
    add_column :site_elements, :version, :string
    add_column :site_elements, :language, :string
    add_column :site_elements, :access_level_id, :integer
    add_index :site_elements, :access_level_id
  end
end
