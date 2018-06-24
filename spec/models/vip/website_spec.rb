require 'rails_helper'

RSpec.describe Vip::Website, type: :model do
  before do
  	@vip_website = FactoryBot.create(:vip_website)
  	@vip_programmer = FactoryBot.create(:vip_programmer)
  end
  context 'Validate Website attributes' do
  	it 'Website should have url attribute' do
  		expect(@vip_website.url).to eq('https://test.com')
  	end
  end
  context 'Validate Website associations' do
  	it 'Website should allow Programmer associations' do
  		@vip_website.programmers << @vip_programmer
  		expect(@vip_website.programmers.count).to eq(1)
  	end
  	it 'Website should allow removal of Programmer associations' do
  		@vip_website.programmers << @vip_programmer
  		expect(@vip_website.programmers.count).to eq(1)
  		@vip_website.programmers.destroy(@vip_programmer)
  		expect(@vip_website.programmers.count).to eq(0)
  	end
  end
end
