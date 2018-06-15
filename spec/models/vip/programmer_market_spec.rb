require 'rails_helper'

RSpec.describe Vip::ProgrammerMarket, type: :model do
  before do
  	@vip_programmer_market = FactoryBot.create(:vip_programmer_market)
  end
  context 'Validate ProgrammerMarket' do
  	it 'ProgrammerMarket should have position attribute' do
  		expect(@vip_programmer_market.position).to eq(1)
  	end
  end
end
