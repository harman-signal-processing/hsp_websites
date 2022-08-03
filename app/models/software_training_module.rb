class SoftwareTrainingModule < ApplicationRecord
  belongs_to :training_module
  belongs_to :software
  validates :training_module_id, uniqueness: {scope: :software_id}
  acts_as_list scope: :software_id
end
