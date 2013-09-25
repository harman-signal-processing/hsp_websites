class CreateMarketingProjectTypeTasks < ActiveRecord::Migration
  def change
    create_table :marketing_project_type_tasks do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
