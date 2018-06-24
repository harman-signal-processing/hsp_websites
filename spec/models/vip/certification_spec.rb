require 'rails_helper'

RSpec.describe Vip::Certification, type: :model do
  before do
  	@vip_certification = FactoryBot.create(:vip_certification)
  	@vip_programmer = FactoryBot.create(:vip_programmer)
  end
  context 'Validate Certification attributes' do
  	it 'Certification should have expected attributes' do
  		expect(@vip_certification.name).to eq('AMX Solution Master')
  	end
  end
  context 'Validate Certification associations' do
		it 'Certification should allow Programmer associations' do
			@vip_certification.programmers << @vip_programmer
			expect(@vip_certification.programmers.count).to eq(1)
		end
		it 'Certification should allow removal of Programmer associations' do
			@vip_certification.programmers << @vip_programmer
			expect(@vip_certification.programmers.count).to eq(1)
			@vip_certification.programmers.destroy(@vip_programmer)
			expect(@vip_certification.programmers.count).to eq(0)
		end
  end
end
