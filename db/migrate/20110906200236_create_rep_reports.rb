class CreateRepReports < ActiveRecord::Migration
  def self.up
    create_table :rep_reports do |t|
      t.integer :clinic_id
      t.integer :overall_impression
      t.integer :clinician_preparation
      t.text :clinician_preparation_comments
      t.boolean :clinician_on_time
      t.integer :attendance
      t.boolean :rebook_clinician
      t.text :best_part
      t.string :worst_part

      t.timestamps
    end
  end

  def self.down
    drop_table :rep_reports
  end
end
