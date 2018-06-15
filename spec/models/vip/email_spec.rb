require 'rails_helper'

RSpec.describe Vip::Email, type: :model do
  before do
  	@vip_email = FactoryBot.create(:vip_email)
  	@vip_programmer = FactoryBot.create(:vip_programmer)
  end
  context 'Validate Email attributes' do
  	it 'Email should have expected attributes' do
  		expect(@vip_email.label).to eq('Email label')
  		expect(@vip_email.email).to eq('test@test.com')
  	end
  end
  context 'Validate Email associations' do
  	it 'Email should allow Programmer associations' do
  		@vip_email.programmers << @vip_programmer
  		expect(@vip_email.programmers.count).to eq(1)
  	end
  	it 'Email should allow removal of Programmer associations' do
  		@vip_email.programmers << @vip_programmer
  		expect(@vip_email.programmers.count).to eq(1)
  		@vip_email.programmers.destroy(@vip_programmer)
  		expect(@vip_email.programmers.count).to eq(0)
  	end
  end
end
