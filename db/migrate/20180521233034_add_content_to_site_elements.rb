class AddContentToSiteElements < ActiveRecord::Migration[5.1]
  def change
    add_column :site_elements, :content, :text
  end
end
