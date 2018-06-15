require 'rails_helper'

RSpec.describe Vip::ServiceCategory, type: :model do
	before do
    @vip_service_category = FactoryBot.create(:vip_service_category)
    @vip_service = FactoryBot.create(:vip_service)
  end
  context 'Validate ServiceCategory attributes' do
    it 'ServiceCategory should have a name' do
      expect(@vip_service_category.name).to eq('Design')
    end
  end
  
  context 'Validate ServiceCategory associations' do
  	it 'ServiceCategory should allow Service associations' do
  		@vip_service_category.services << @vip_service
  		expect(@vip_service_category.services.count).to eq(1)
  	end
  	it 'ServiceCategory should allow removal of Service associations' do
  		@vip_service_category.services << @vip_service
  		expect(@vip_service_category.services.count).to eq(1)
  		@vip_service_category.services.destroy(@vip_service)
  		expect(@vip_service_category.services.count).to eq(0)
  	end
  end
end
