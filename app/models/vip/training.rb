class Vip::Training < ApplicationRecord
	validates :name, presence: true
	
	has_many :programmer_trainings, dependent: :destroy, foreign_key: "vip_training_id"
	has_many :programmers, through: :programmer_trainings
	
  scope :not_associated_with_this_programmer, -> (programmer) { 
    training_ids_already_associated_with_this_programmer = Vip::ProgrammerTraining.where("vip_programmer_id = ?", programmer.id).map{|programmer_training| programmer_training.vip_training_id }
    trainings_not_associated_with_this_programmer = self.where.not(id: training_ids_already_associated_with_this_programmer)    
    trainings_not_associated_with_this_programmer
  }		
	
end
