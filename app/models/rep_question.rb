class RepQuestion < ActiveRecord::Base
  belongs_to :rep_report, :inverse_of => :rep_questions
  validates_presence_of :rep_report
  acts_as_list :scope => :rep_report_id
end
