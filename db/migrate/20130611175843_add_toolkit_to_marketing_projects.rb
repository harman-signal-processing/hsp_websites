class AddToolkitToMarketingProjects < ActiveRecord::Migration
  def change
    add_column :marketing_projects, :put_source_on_toolkit, :boolean
    add_column :marketing_projects, :put_final_on_toolkit, :boolean
  end
end
