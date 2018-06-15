class Vip::Skill < ApplicationRecord
	validates :name, presence: true
	
	has_many :programmer_skills, dependent: :destroy, foreign_key: "vip_skill_id"
	has_many :programmers, through: :programmer_skills
	
end
