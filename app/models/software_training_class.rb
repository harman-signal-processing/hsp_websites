class SoftwareTrainingClass < ActiveRecord::Base
  belongs_to :training_class
  belongs_to :software
  validates :software_id, :presence => true
  validates :training_class_id, :presence => true, :uniqueness => {:scope => :software_id}
end
