class AddSlugToSiteElements < ActiveRecord::Migration
  def change
    add_column :site_elements, :cached_slug, :string
    add_index :site_elements, :cached_slug
  end
end
