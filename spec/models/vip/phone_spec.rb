require 'rails_helper'

RSpec.describe Vip::Phone, type: :model do
	before do
		@vip_phone = FactoryBot.create(:vip_phone)
		@vip_programmer = FactoryBot.create(:vip_programmer)
	end
	context 'Validate Phone attributes' do
		it 'Phone should have phone attribute' do
			expect(@vip_phone.phone).to eq('123-456-7890')
		end
	end
	context 'Validate Phone associations' do
		it 'Phone should allow Programmer associations' do
			@vip_phone.programmers << @vip_programmer
			expect(@vip_phone.programmers.count).to eq(1)
		end
		it 'Phone should allow removal of Programmer associations' do
			@vip_phone.programmers << @vip_programmer
			expect(@vip_phone.programmers.count).to eq(1)
			@vip_phone.programmers.destroy(@vip_programmer)
			expect(@vip_phone.programmers.count).to eq(0)
		end
	end
end
