class CreateSoftwareReports < ActiveRecord::Migration[6.1]
  def change
    create_table :software_reports do |t|
      t.integer :software_id
      t.integer :previous_count
      t.date :previous_count_on

      t.timestamps
    end

    software = Software.where(name: "Crown I-Tech HD - Q-SYS Plugin").first
    SoftwareReport.create(software: software)
  end
end
