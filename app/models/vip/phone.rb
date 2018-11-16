class Vip::Phone < ApplicationRecord
	validates :phone, presence: true
	
	has_many :programmer_phones, dependent: :destroy, foreign_key: "vip_phone_id"
	has_many :programmers, through: :programmer_phones
	
  scope :not_associated_with_this_programmer, -> (programmer) { 
    phone_ids_already_associated_with_this_programmer = Vip::ProgrammerPhone.where("vip_programmer_id = ?", programmer.id).map{|programmer_phone| programmer_phone.vip_phone_id }
    phones_not_associated_with_this_programmer = Vip::Phone.where.not(id: phone_ids_already_associated_with_this_programmer)    
    phones_not_associated_with_this_programmer
  }	
	
end
