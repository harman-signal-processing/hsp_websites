require 'rails_helper'

RSpec.describe Vip::GlobalRegion, type: :model do
  context 'Validate GlobalRegion attributes' do
    before do
      @vip_global_region = FactoryBot.create(:vip_global_region)  
    end
    
    it 'GlobalRegion should have a name' do
      expect(@vip_global_region.name).to eq('North America')
    end
  end

end