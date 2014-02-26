class ClinicianQuestion < ActiveRecord::Base
  belongs_to :clinician_report, inverse_of: :clinician_questions
  validates :clinician_report, presence: true
  acts_as_list scope: :clinician_report_id
end
