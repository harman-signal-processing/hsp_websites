class CreateRsoPersonalReports < ActiveRecord::Migration
  def self.up
    create_table :rso_personal_reports do |t|
      t.integer :user_id
      t.string :rso_personal_report_file_name
      t.integer :rso_personal_report_file_size
      t.string :rso_personal_report_content_type
      t.datetime :rso_personal_report_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :rso_personal_reports
  end
end
