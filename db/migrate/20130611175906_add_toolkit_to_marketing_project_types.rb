class AddToolkitToMarketingProjectTypes < ActiveRecord::Migration
  def change
    add_column :marketing_project_types, :put_source_on_toolkit, :boolean
    add_column :marketing_project_types, :put_final_on_toolkit, :boolean
  end
end
