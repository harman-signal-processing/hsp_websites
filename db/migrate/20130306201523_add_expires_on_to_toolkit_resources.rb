class AddExpiresOnToToolkitResources < ActiveRecord::Migration
  def change
    add_column :toolkit_resources, :expires_on, :date
  end
end
