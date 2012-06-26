class ConvertWorstPartToTextareas < ActiveRecord::Migration
  def self.up
    change_column :clinician_reports, :worst_part, :text
    change_column :rep_reports, :worst_part, :text
  end

  def self.down
    change_column :rep_reports, :worst_part, :string
    change_column :clinician_reports, :worst_part, :string
  end
end