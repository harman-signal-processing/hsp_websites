class CreateClinicianQuestions < ActiveRecord::Migration
  def self.up
    create_table :clinician_questions do |t|
      t.integer :clinician_report_id
      t.integer :position
      t.text :question

      t.timestamps
    end
  end

  def self.down
    drop_table :clinician_questions
  end
end
