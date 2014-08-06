class RemoveOldClinicianStuff < ActiveRecord::Migration
  def change
    drop_table :clinic_products
    drop_table :clinician_questions
    drop_table :clinician_reports
    drop_table :clinics
    drop_table :rep_reports
    drop_table :rep_questions

    remove_column :brands, :has_clinics
    remove_column :users, :clinic_admin
  end
end
