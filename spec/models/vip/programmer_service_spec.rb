require 'rails_helper'

RSpec.describe Vip::ProgrammerService, type: :model do
  before do
  	@vip_programmer_service = FactoryBot.create(:vip_programmer_service)
  end
  context 'Validate ProgrammerService' do
  	it 'ProgrammerService should have position attribute' do
  		expect(@vip_programmer_service.position).to eq(1)
  	end
  end
end
