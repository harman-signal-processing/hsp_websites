class Vip::Training < ApplicationRecord
	validates :name, presence: true
	
	has_many :programmer_trainings, dependent: :destroy, foreign_key: "vip_training_id"
	has_many :programmers, through: :programmer_trainings
	
end
