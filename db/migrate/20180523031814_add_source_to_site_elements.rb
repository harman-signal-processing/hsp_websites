class AddSourceToSiteElements < ActiveRecord::Migration[5.1]
  def change
    add_column :site_elements, :source, :string
  end
end
