class AddProjectManagerFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :project_manager, :boolean
  end
end
