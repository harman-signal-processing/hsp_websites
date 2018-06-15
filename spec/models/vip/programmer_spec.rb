require 'rails_helper'

RSpec.describe Vip::Programmer, type: :model do
	before do
  	@vip_programmer = FactoryBot.create(:vip_programmer)
  	@vip_location = FactoryBot.create(:vip_location)
  	@vip_service = FactoryBot.create(:vip_service)
  	@vip_certification = FactoryBot.create(:vip_certification)
  	@vip_training = FactoryBot.create(:vip_training)
  	@vip_skill = FactoryBot.create(:vip_skill)
  	@vip_website = FactoryBot.create(:vip_website)
  	@vip_email = FactoryBot.create(:vip_email)
  	@vip_phone = FactoryBot.create(:vip_phone)
  	@vip_market = FactoryBot.create(:vip_market)
  end
  context 'Validate Programmer attributes' do

  	it 'Programmer should have expected attributes' do
  		expect(@vip_programmer.name).to eq('Programmer 1')
  		expect(@vip_programmer.description).to eq('Programmer 1 description')
  		expect(@vip_programmer.examples).to eq('Programmer 1 examples')
  		expect(@vip_programmer.security_clearance).to eq('Programmer 1 security_clearance')
  	end
  	
  end
  
  context 'Validate Programmer associations' do
  	it 'Programmer should allow Location associations' do
  		@vip_programmer.locations << @vip_location
  		expect(@vip_programmer.locations.count).to eq(1)
  	end
  	it 'Programmer should allow removal of Location associations' do
			@vip_programmer.locations << @vip_location
  		expect(@vip_programmer.locations.count).to eq(1)  		
  		@vip_programmer.locations.destroy(@vip_location)
  		expect(@vip_programmer.locations.count).to eq(0)
  	end
  	
  	it 'Programmer should allow Service associations' do
  		@vip_programmer.services << @vip_service
  		expect(@vip_programmer.services.count).to eq(1)
  	end
  	it 'Programmer should allow removal of Service associations' do
  		@vip_programmer.services << @vip_service
  		expect(@vip_programmer.services.count).to eq(1)
  		@vip_programmer.services.destroy(@vip_service)
  		expect(@vip_programmer.services.count).to eq(0)
  	end
  	
  	it 'Programmer should allow Certification associations' do
  		@vip_programmer.certifications << @vip_certification
  		expect(@vip_programmer.certifications.count).to eq(1)
  	end
  	it 'Programmer should allow removal of Certification associations' do
  		@vip_programmer.certifications << @vip_certification
  		expect(@vip_programmer.certifications.count).to eq(1)
  		@vip_programmer.certifications.destroy(@vip_certification)
  		expect(@vip_programmer.certifications.count).to eq(0)
  	end
  	
  	it 'Programmer should allow Training associations' do
  		@vip_programmer.trainings << @vip_training
  		expect(@vip_programmer.trainings.count).to eq(1)
  	end
  	it 'Programmer should allow removal of Training associations' do
  		@vip_programmer.trainings << @vip_training
  		expect(@vip_programmer.trainings.count).to eq(1)
  		@vip_programmer.trainings.destroy(@vip_training)
  		expect(@vip_programmer.trainings.count).to eq(0)
  	end  	
  	
  	it 'Programmer should allow Skill associations' do
  		@vip_programmer.skills << @vip_skill
  		expect(@vip_programmer.skills.count).to eq(1)
  	end
  	it 'Programmer should allow removal of Skill associations' do
  		@vip_programmer.skills << @vip_skill
  		expect(@vip_programmer.skills.count).to eq(1)
  		@vip_programmer.skills.destroy(@vip_skill)
  		expect(@vip_programmer.skills.count).to eq(0)
  	end
  	
  	it 'Programmer should allow Website associations' do
  		@vip_programmer.websites << @vip_website
  		expect(@vip_programmer.websites.count).to eq(1)
  	end
  	it 'Programmer should allow removal of Websites associations' do
  		@vip_programmer.websites << @vip_website
  		expect(@vip_programmer.websites.count).to eq(1)
  		@vip_programmer.websites.destroy(@vip_website)
  		expect(@vip_programmer.websites.count).to eq(0)
  	end  	
  	
  	it 'Programmer should allow Email associations' do
  		@vip_programmer.emails << @vip_email
  		expect(@vip_programmer.emails.count).to eq(1)
  	end
  	it 'Programmer should allow removal of Email associations' do
  		@vip_programmer.emails << @vip_email
  		expect(@vip_programmer.emails.count).to eq(1)
  		@vip_programmer.emails.destroy(@vip_email)
  		expect(@vip_programmer.emails.count).to eq(0)
  	end  	
  	
  	it 'Programmer should allow Phone associations' do
  		@vip_programmer.phones << @vip_phone
  		expect(@vip_programmer.phones.count).to eq(1)
  	end
  	it 'Programmer should allow removal of Phone associations' do
  		@vip_programmer.phones << @vip_phone
  		expect(@vip_programmer.phones.count).to eq(1)
  		@vip_programmer.phones.destroy(@vip_phone)
  		expect(@vip_programmer.phones.count).to eq(0)
  	end  	
  	
  	it 'Programmer should allow Market associations' do
  		@vip_programmer.markets << @vip_market
  		expect(@vip_programmer.markets.count).to eq(1)
  	end
  	it 'Programmer should allow removal of Market associations' do
  		@vip_programmer.markets << @vip_market
  		expect(@vip_programmer.markets.count).to eq(1)
  		@vip_programmer.markets.destroy(@vip_market)
  		expect(@vip_programmer.markets.count).to eq(0)
  	end  	
  	
    # skipping SiteElement association tests for now because of issues with FactoryBot.build_stubbed(:site_element)
  	
  end  #  context 'Validate Programmer associations' do
  
end
