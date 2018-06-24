require 'rails_helper'

RSpec.describe Vip::ProgrammerLocation, type: :model do
    context 'Validate ProgrammerLocation has position' do
    before do
      @vip_programmer_location = FactoryBot.create(:vip_programmer_location)
    end
    
    it 'ProgrammerLocation has postition attribute' do
      expect(@vip_programmer_location.position).to eq(1)
    end
  end
end
