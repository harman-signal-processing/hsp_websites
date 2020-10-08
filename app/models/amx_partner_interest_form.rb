class AmxPartnerInterestForm < ApplicationRecord
	validates :company_name, :company_url, :first_name, :last_name, :email, presence: true
end
