require 'rails_helper'

RSpec.describe Vip::ServiceArea, type: :model do
  context 'Validate ServiceArea attributes' do
    before do
      @vip_service_area = FactoryBot.create(:vip_service_area)
    end
    it 'ServiceArea should have a name' do
      expect(@vip_service_area.name).to eq('National')
    end
  end
end
