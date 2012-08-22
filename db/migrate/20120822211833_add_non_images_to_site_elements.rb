class AddNonImagesToSiteElements < ActiveRecord::Migration
  def change
  	add_column :site_elements, :executable_file_name, :string
  	add_column :site_elements, :executable_content_type, :string
  	add_column :site_elements, :executable_file_size, :integer
  	add_column :site_elements, :executable_updated_at, :datetime
  end
end
