class RepReport < ActiveRecord::Base
  belongs_to :clinic
  validates_presence_of :clinic_id
  has_many :rep_questions, :order => :position, :inverse_of => :rep_report
  accepts_nested_attributes_for :rep_questions, :reject_if => :all_blank
end
