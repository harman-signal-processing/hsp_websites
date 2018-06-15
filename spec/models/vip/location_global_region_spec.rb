require 'rails_helper'

RSpec.describe Vip::LocationGlobalRegion, type: :model do
  context 'Validate LocationGlobalRegion has position' do
    before do
      @vip_location_global_region = FactoryBot.create(:vip_location_global_region)
    end
    
    it 'LocationGlobalRegion has postition attribute' do
      expect(@vip_location_global_region.position).to eq(1)
    end
    
  end
end
