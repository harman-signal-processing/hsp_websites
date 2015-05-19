class AddContactToSystemConfigurations < ActiveRecord::Migration
  def change
    add_column :system_configurations, :project_name, :string
    add_column :system_configurations, :email, :string
    add_column :system_configurations, :phone, :string
    add_column :system_configurations, :company, :string
    add_column :system_configurations, :preferred_contact_method, :string
    add_column :system_configurations, :access_hash, :string
  end
end
