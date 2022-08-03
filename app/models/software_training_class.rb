class SoftwareTrainingClass < ApplicationRecord
  belongs_to :training_class
  belongs_to :software
  validates :training_class_id, uniqueness: {scope: :software_id}
end
