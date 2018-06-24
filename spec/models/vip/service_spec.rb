require 'rails_helper'

RSpec.describe Vip::Service, type: :model do
  before do
  	@vip_service = FactoryBot.create(:vip_service)
  	@vip_service_category = FactoryBot.create(:vip_service_category)
  	@vip_programmer = FactoryBot.create(:vip_programmer)
  end
  context 'Validate Service attributes' do
  	it 'Service should have name' do
  		expect(@vip_service.name).to eq('Touch Panel Design')
  	end
  end
  context 'Validate Service associations' do
  	it 'Service should allow ServiceCategory associations' do
  		@vip_service.categories << @vip_service_category
  		expect(@vip_service.categories.count).to eq(1)
  	end
  	it 'Service should allow removal of ServiceCategory association' do
  		@vip_service.categories << @vip_service_category
      expect(@vip_service.categories.count).to eq(1)
      @vip_service.categories.destroy(@vip_service_category)
      expect(@vip_service.categories.count).to eq(0)
  	end
  	
  	it 'Service should allow Programmer association' do
			@vip_service.programmers << @vip_programmer
			expect(@vip_service.programmers.count).to eq(1)
  	end
  	it 'Service should allow removal of Programmer association' do
  		@vip_service.programmers << @vip_programmer
			expect(@vip_service.programmers.count).to eq(1)
			@vip_service.programmers.destroy(@vip_programmer)
			expect(@vip_service.programmers.count).to eq(0)
  	end
  end
end
