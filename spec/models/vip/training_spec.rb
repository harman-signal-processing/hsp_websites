require 'rails_helper'

RSpec.describe Vip::Training, type: :model do
  before do
  	@vip_training = FactoryBot.create(:vip_training)
  	@vip_programmer = FactoryBot.create(:vip_programmer)
  end
  context 'Validate Training attributes' do
  	it 'Training should have a name attribute' do
  		expect(@vip_training.name).to eq('AMX')
  	end
  end
  context 'Validate Training associations' do
  	it 'Training should allow Programmer associations' do
  		@vip_training.programmers << @vip_programmer
  		expect(@vip_training.programmers.count).to eq(1)
  	end
  	it 'Training should allow removal of Programmer associations' do
  		@vip_training.programmers << @vip_programmer
  		expect(@vip_training.programmers.count).to eq(1)
  		@vip_training.programmers.destroy(@vip_programmer)
  		expect(@vip_training.programmers.count).to eq(0)
  	end
  end
end
