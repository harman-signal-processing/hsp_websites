class AddBroadCategoriesToSiteElements < ActiveRecord::Migration
  def up
    add_column :site_elements, :is_document, :boolean
    add_column :site_elements, :is_software, :boolean

    SiteElement.update_all(is_document: true)
    SiteElement.where("executable_file_name LIKE '%.exe'").update_all(is_document: false, is_software: true)
  end

  def down
    remove_column :site_elements, :is_document
    remove_column :site_elements, :is_software
  end
end
