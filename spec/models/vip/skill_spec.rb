require 'rails_helper'

RSpec.describe Vip::Skill, type: :model do
  before do
  	@vip_skill = FactoryBot.create(:vip_skill)
  	@vip_programmer = FactoryBot.create(:vip_programmer)
  end
  context 'Validate Skill attributes' do
  	it 'Skill should have name attribute'	do
  		expect(@vip_skill.name).to eq('AMX Duet Developer')
  	end
  end
  context 'Validate Skill associations' do
  	it 'Skill should allow Programmer associations' do
  		@vip_skill.programmers << @vip_programmer
  		expect(@vip_skill.programmers.count).to eq(1)
  	end
  	it 'Skill should allow removal of Programmer associations' do
  		@vip_skill.programmers << @vip_programmer
  		expect(@vip_skill.programmers.count).to eq(1)
  		@vip_skill.programmers.destroy(@vip_programmer)
  		expect(@vip_skill.programmers.count).to eq(0)
  	end
  end
end
