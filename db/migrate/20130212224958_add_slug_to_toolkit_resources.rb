class AddSlugToToolkitResources < ActiveRecord::Migration
  def change
    add_column :toolkit_resources, :slug, :string
    add_index :toolkit_resources, :slug
  end
end
