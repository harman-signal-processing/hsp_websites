class CreateMarketingProjectTypes < ActiveRecord::Migration
  def change
    create_table :marketing_project_types do |t|
      t.string :name
      t.boolean :major_effort

      t.timestamps
    end
  end
end
