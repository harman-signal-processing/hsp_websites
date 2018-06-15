require 'rails_helper'

RSpec.describe Vip::LocationServiceArea, type: :model do
	before do
		@vip_location_service_area = FactoryBot.create(:vip_location_service_area)
	end
  context 'Validate LocationServiceArea' do
  	it 'LocationServiceArea should have position attribute' do
  		expect(@vip_location_service_area.position).to eq(1)
  	end
  end
end
