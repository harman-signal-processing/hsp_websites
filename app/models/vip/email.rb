class Vip::Email < ApplicationRecord
	validates :email, presence: true
	
	has_many :programmer_emails, dependent: :destroy, foreign_key: "vip_email_id"
	has_many :programmers, through: :programmer_emails
end
