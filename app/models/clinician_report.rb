class ClinicianReport < ActiveRecord::Base
  belongs_to :clinic
  validates_presence_of :clinic
  has_many :clinician_questions, :order => :position, :inverse_of => :clinician_report
  accepts_nested_attributes_for :clinician_questions, :reject_if => :all_blank
  accepts_nested_attributes_for :clinic, :reject_if => :all_blank
end
