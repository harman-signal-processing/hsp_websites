require 'rails_helper'

RSpec.describe Vip::Market, type: :model do
	before do
		@vip_market = FactoryBot.create(:vip_market)
		@vip_programmer = FactoryBot.create(:vip_programmer)
	end
	context 'Validate Market attributes' do
		it 'Market should have name attribute' do
			expect(@vip_market.name).to eq('Education')
		end
	end
	context 'Validate Market associations' do
  	it 'Market should allow Programmer associations' do
  		@vip_market.programmers << @vip_programmer
  		expect(@vip_market.programmers.count).to eq(1)
  	end
  	it 'Market should allow removal of Programmer associations' do
  		@vip_market.programmers << @vip_programmer
  		expect(@vip_market.programmers.count).to eq(1)
  		@vip_market.programmers.destroy(@vip_programmer)
  		expect(@vip_market.programmers.count).to eq(0)
  	end
  end
end
