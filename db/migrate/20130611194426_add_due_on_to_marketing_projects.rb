class AddDueOnToMarketingProjects < ActiveRecord::Migration
  def change
    add_column :marketing_projects, :due_on, :date
  end
end
