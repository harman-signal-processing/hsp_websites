class CreateRsoMonthlyReports < ActiveRecord::Migration
  def self.up
    create_table :rso_monthly_reports do |t|
      t.string :name
      t.text :content
      t.integer :brand_id
      t.string :rso_report_file_name
      t.integer :rso_report_file_size
      t.string :rso_report_content_type
      t.datetime :rso_report_updated_at
      t.integer :updated_by_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rso_monthly_reports
  end
end
