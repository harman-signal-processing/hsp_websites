require 'rails_helper'

RSpec.describe Vip::Location, type: :model do
	before do
  	@vip_location = FactoryBot.create(:vip_location)
  	@vip_global_region = FactoryBot.create(:vip_global_region)
  	@vip_service_area = FactoryBot.create(:vip_service_area)
  end
	
  context 'Validate Location attributes' do
  	it 'Location should have expected attributes' do
  		expect(@vip_location.name).to eq('Location name')
  		expect(@vip_location.city).to eq('Location city')
  		expect(@vip_location.state).to eq('Location state')
  		expect(@vip_location.country).to eq('Location country')
  	end
  end
  
  context 'Validate Location associations' do
  	it 'Location should allow GlobalRegion associations' do
  		@vip_location.global_regions << @vip_global_region
  		expect(@vip_location.global_regions.count).to eq(1)
  	end
  	it 'Location should allow removal of GlobalRegion associations' do
  		@vip_location.global_regions << @vip_global_region
  		expect(@vip_location.global_regions.count).to eq(1)
  		@vip_location.global_regions.destroy(@vip_global_region)
  		expect(@vip_location.global_regions.count).to eq(0)
  	end
  	
  	it 'Location should allow ServiceArea associations' do
  		@vip_location.service_areas << @vip_service_area
  		expect(@vip_location.service_areas.count).to eq(1)
  	end
  	it 'Location should allow removal of ServiceArea associations' do
  		@vip_location.service_areas << @vip_service_area
  		expect(@vip_location.service_areas.count).to eq(1)
  		@vip_location.service_areas.destroy(@vip_service_area)
  		expect(@vip_location.service_areas.count).to eq(0)
  	end
  end
  
end
