class ClinicianQuestion < ActiveRecord::Base
  belongs_to :clinician_report, :inverse_of => :clinician_questions
  validates_presence_of :clinician_report
  acts_as_list :scope => :clinician_report_id
end
