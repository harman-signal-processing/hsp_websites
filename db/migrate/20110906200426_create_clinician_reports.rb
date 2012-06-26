class CreateClinicianReports < ActiveRecord::Migration
  def self.up
    create_table :clinician_reports do |t|
      t.integer :clinic_id
      t.integer :overall_impression
      t.text :regional_competitors
      t.boolean :rep_planned
      t.text :rep_planned_comments
      t.text :best_part
      t.string :worst_part

      t.timestamps
    end
  end

  def self.down
    drop_table :clinician_reports
  end
end
