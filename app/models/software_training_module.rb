class SoftwareTrainingModule < ActiveRecord::Base
  belongs_to :training_module
  belongs_to :software
  validates :software_id, presence: true
  validates :training_module_id, presence: true, uniqueness: {scope: :software_id}
  acts_as_list scope: :software_id
end
