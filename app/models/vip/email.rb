class Vip::Email < ApplicationRecord
	validates :email, presence: true
	
	has_many :programmer_emails, dependent: :destroy, foreign_key: "vip_email_id"
	has_many :programmers, through: :programmer_emails
	
  scope :not_associated_with_this_programmer, -> (programmer) { 
    email_ids_already_associated_with_this_programmer = Vip::ProgrammerEmail.where("vip_programmer_id = ?", programmer.id).map{|programmer_email| programmer_email.vip_email_id }
    emails_not_associated_with_this_programmer = self.where.not(id: email_ids_already_associated_with_this_programmer)    
    emails_not_associated_with_this_programmer
  }	
  
end
